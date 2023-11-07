defmodule PentoWeb.UserControllerTest do
  use PentoWeb.ConnCase

  import Pento.AccountsFixtures
  import OpenApiSpex.TestAssertions

  alias Pento.Accounts.User

  @update_attrs %{
    username: "some updated username"
  }
  @invalid_attrs %{username: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users")
      result = json_response(conn, 200)

      assert_response_schema result, "UserListResponse", api_spec()

      assert result["data"] == [
               %{"id" => user.id, "username" => user.username, "email" => user.email}
             ]
    end
  end

  describe "show" do
    setup [:create_user]

    test "show a user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users/#{user}")
      result = json_response(conn, 200)

      assert_response_schema result, "UserResponse", api_spec()

      assert result["data"] == %{
               "id" => user.id,
               "username" => user.username,
               "email" => user.email
             }
    end

    test "example test" do
      schema = PentoWeb.Schema.UserResponse.schema()
      assert_schema(schema.example, "UserResponse", api_spec())
    end
  end

  describe "register user" do
    test "renders user when data is valid", %{conn: conn} do
      username = unique_username()
      email = unique_user_email()

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(~p"/api/users",
          user: valid_user_attributes(%{username: username, email: email})
        )

      assert %{"data" => %{"id" => id}} = result = json_response(conn, 201)
      assert_response_schema result, "UserResponse", api_spec()

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => ^email,
               "username" => ^username
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(~p"/api/users", user: @invalid_attrs)

      result = json_response(conn, 422)
      assert_response_schema result, "CommonErrorResponse", api_spec()
      assert result["errors"] != []
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(~p"/api/users/#{user}", user: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      email = user.email

      assert %{
               "id" => ^id,
               "email" => ^email,
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(~p"/api/users/#{user}", user: @invalid_attrs)

      result = json_response(conn, 422)
      assert_response_schema result, "CommonErrorResponse", api_spec()
      assert result["errors"] != []
    end

    test "renders errors when not found user", %{conn: conn} do
      {404, _, json} =
        assert_error_sent 404, fn ->
          conn =
            conn
            |> put_req_header("content-type", "application/json")
            |> put(~p"/api/users/#{9_999_999}", user: @update_attrs)
        end

      result = Jason.decode!(json)
      assert_response_schema result, "CommonErrorResponse", api_spec()
      assert result["errors"] != []
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
