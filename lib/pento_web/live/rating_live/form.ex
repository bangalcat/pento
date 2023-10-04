defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign_rating() |> clear_form()}
  end

  def assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def clear_form(%{assigns: %{rating: rating}} = socket) do
    assign_form(socket, Survey.change_rating(rating))
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, save_rating(socket, rating_params)}
  end

  def save_rating(
        %{assigns: %{product_index: product_index, product: product}} = socket,
        rating_params
      ) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end
end
