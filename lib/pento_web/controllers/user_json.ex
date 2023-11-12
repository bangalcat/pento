defmodule PentoWeb.UserJSON do
  alias Pento.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users, cursor: cursor, total: total}) do
    %{data: for(user <- users, do: data(user)), cursor: cursor, total: total}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
