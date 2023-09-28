defmodule PentoWeb.FaqLive.Index do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Faq

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :faqs, Catalog.list_faqs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Faq")
    |> assign(:faq, Catalog.get_faq!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Faq")
    |> assign(:faq, %Faq{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Faqs")
    |> assign(:faq, nil)
  end

  @impl true
  def handle_info({PentoWeb.FaqLive.FormComponent, {:saved, faq}}, socket) do
    {:noreply, stream_insert(socket, :faqs, faq)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    faq = Catalog.get_faq!(id)
    {:ok, _} = Catalog.delete_faq(faq)

    {:noreply, stream_delete(socket, :faqs, faq)}
  end

  def handle_event("upvote", %{"id" => id}, socket) do
    faq = Catalog.get_faq!(id)
    {:ok, faq} = Catalog.upvote_faq(faq)

    {:noreply, stream_insert(socket, :faqs, faq)}
  end
end
