defmodule PentoWeb.ProductControllerTest do
  use PentoWeb.ConnCase

  import Pento.CatalogFixtures
  import OpenApiSpex.TestAssertions

  alias Pento.Catalog.Category
  alias Pento.Catalog.Product

  @create_attrs %{
    name: "some name",
    description: "some description",
    unit_price: 120.5,
    sku: 42,
    image_upload: %Plug.Upload{filename: "example.png", path: "test/fixtures/example.png"}
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    unit_price: 456.7,
    sku: 43,
    image_upload: %Plug.Upload{filename: "example.png", path: "test/fixtures/example.png"}
  }
  @invalid_attrs %{name: nil, description: nil, unit_price: nil, sku: nil, image_upload: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup [:register_and_log_in_user, :setup_auth]

  describe "index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, product: %{id: id}} do
      conn = get(conn, ~p"/api/products")
      result = json_response(conn, 200)
      assert_response_schema result, "ProductListResponse", api_spec()
      assert %{"cursor" => _, "total" => 1, "data" => [%{"id" => ^id}]} = result
    end
  end

  describe "create product" do
    setup [:setup_category]

    test "renders product when data is valid", %{conn: conn, category: cat} do
      attrs = @create_attrs |> Map.put(:categories, [cat.title])

      conn =
        conn
        |> post(~p"/api/products", attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      result = json_response(conn, 200)

      assert_response_schema result, "ProductResponse", api_spec()

      assert result["data"] == %{
               "id" => id,
               "description" => "some description",
               "image_upload" => "/images/example.png",
               "name" => "some name",
               "sku" => 42,
               "unit_price" => 120.5,
               "categories" => [cat.title],
               "ratings" => nil
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", @invalid_attrs)
      result = json_response(conn, 400)
      assert_response_schema result, "ErrorResponse", api_spec()
      assert result["error"] == %{"code" => "invalid_parameter", "message" => "invalid_parameter"}
    end
  end

  describe "update product" do
    setup [:create_product, :setup_category]

    test "renders product when data is valid", %{
      conn: conn,
      product: %Product{id: id} = product,
      category: %Category{title: title}
    } do
      attrs = @update_attrs |> Map.put(:categories, [title])
      conn = put(conn, ~p"/api/products/#{product}", attrs)
      result = json_response(conn, 200)
      assert_response_schema result, "ProductResponse", api_spec()
      assert %{"id" => ^id} = result["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "image_upload" => "/images/example.png",
               "name" => "some updated name",
               "sku" => 43,
               "unit_price" => 456.7,
               "categories" => [^title]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, ~p"/api/products/#{product}", @invalid_attrs)
      result = json_response(conn, 400)
      assert_response_schema result, "ErrorResponse", api_spec()
      assert result["error"] == %{"code" => "invalid_parameter", "message" => "invalid_parameter"}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, ~p"/api/products/#{product}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/products/#{product}")
      end
    end
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp setup_category(_) do
    category = category_fixture(%{title: "RPG"})
    %{category: category}
  end

  def setup_auth(%{current_user: user, conn: conn}) do
    conn = put_req_header(conn, "authorization", "Bearer user:#{user.id}")
    %{conn: conn}
  end
end
