defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view

  alias Pento.Catalog.Search
  alias Pento.Catalog

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_search() |> clear_form() |> stream(:products, [])}
  end

  def assign_search(socket) do
    socket |> assign(:search, %Search{})
  end

  def clear_form(socket) do
    changeset = socket.assigns.search |> Catalog.change_search()
    assign_form(socket, changeset)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"search" => search_params},
        %{assigns: %{search: search}} = socket
      ) do
    changeset = Catalog.change_search(search, search_params) |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("search", %{"search" => search_params}, socket) do
    case Catalog.apply_search(socket.assigns.search, search_params) do
      {:ok, search} ->
        products = Catalog.search_product(search)

        {:noreply, stream(socket, :products, products, reset: true)}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end
end
