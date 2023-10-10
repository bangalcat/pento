defmodule PentoWeb.Admin.UserActivityLive do
  use PentoWeb, :live_component

  alias PentoWeb.Presence

  def update(assigns, socket) do
    {:ok, assign(socket, assigns) |> assign_user_acitivity()}
  end

  def assign_user_acitivity(socket) do
    products_and_users = Presence.list_products_and_users()

    socket
    |> assign(:user_activity, products_and_users)
  end
end
