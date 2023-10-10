defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias PentoWeb.DemographicLive
  alias PentoWeb.RatingLive
  alias PentoWeb.Endpoint
  alias PentoWeb.Presence

  alias Pento.Survey
  alias Pento.Catalog

  alias __MODULE__.Component

  @survey_results_topic "survey_results"

  def mount(_params, _session, socket) do
    maybe_track_user(socket)

    {:ok,
     socket
     |> assign_demographic()
     |> assign_products()
     |> assign(:demographic_editable, false)}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end

  def handle_event("edit_demographic", _, socket) do
    {:noreply, assign(socket, :demographic_editable, true)}
  end

  def handle_info({:updated_demographic, demographic}, socket) do
    {:noreply, handle_demographic_updated(socket, demographic)}
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  def handle_demographic_updated(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic updated successfully")
    |> assign(:demographic, demographic)
    |> assign(:demographic_editable, false)
  end

  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
    |> assign(:demographic_editable, false)
  end

  def handle_rating_created(
        %{assigns: %{products: products}} = socket,
        updated_product,
        product_index
      ) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(:products, List.replace_at(products, product_index, updated_product))
  end

  def assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Catalog.list_products_with_user_rating(user)
  end

  def maybe_track_user(%{assigns: %{current_user: current_user}} = socket) do
    if connected?(socket) do
      Presence.track_survey_user(self(), current_user.email)
    end
  end

  def maybe_track_user(_product, _socket), do: nil
end
