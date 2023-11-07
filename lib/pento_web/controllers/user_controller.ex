defmodule PentoWeb.UserController do
  use PentoWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Pento.Accounts
  alias Pento.Accounts.User

  alias PentoWeb.Schema.UserParams
  alias PentoWeb.Schema.UserUpdateParams
  alias PentoWeb.Schema.UserResponse
  alias PentoWeb.Schema.UserListResponse
  alias PentoWeb.Schema.ErrorResponse

  action_fallback PentoWeb.FallbackController

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  tags ["users"]

  operation :index,
    summary: "User list",
    responses: [
      ok: {"User list response", "application/json", UserListResponse}
    ]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  operation :create,
    summary: "Create user",
    request_body: {"User params", "application/json", UserParams},
    responses: %{
      201 => {"User created Response", "application/json", UserResponse}
    }

  def create(conn, _) do
    %{user: user_params} = OpenApiSpex.body_params(conn)

    with {:ok, %User{} = user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  operation :show,
    summary: "Show user",
    parameters: [
      id: [in: :path, description: "User ID", type: :integer]
    ],
    responses: [
      ok: {"User response", "application/json", UserResponse},
      not_found: {"User not found", "application/json", ErrorResponse}
    ]

  def show(conn, %{id: id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  operation :update,
    summary: "Update user",
    parameters: [
      id: [in: :path, description: "User ID", type: :integer]
    ],
    request_body: {"User params", "application/json", UserUpdateParams},
    responses: [
      ok: {"Updated User response", "application/json", UserResponse},
      not_found: {"User not found", "application/json", ErrorResponse}
    ]

  def update(conn, %{:id => id}) do
    %{user: user_params} = OpenApiSpex.body_params(conn)
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user_info(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  operation :delete,
    summary: "Delete user",
    parameters: [
      id: [in: :path, description: "User ID", type: :integer]
    ],
    responses: [
      no_content: {"User deleted", "application/json", nil},
      not_found: {"User not found", "application/json", ErrorResponse}
    ]

  def delete(conn, %{:id => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
