defmodule PentoWeb.ProductController do
  use PentoWeb, :controller
  import OpenApiSpex.Operation, only: [parameter: 5, request_body: 4, response: 3]

  alias OpenApiSpex.Operation

  alias Pento.Catalog
  alias Pento.Catalog.Product

  alias PentoWeb.Schema.CreateProductParams
  alias PentoWeb.Schema.UpdateProductParams
  alias PentoWeb.Schema.ProductListResponse
  alias PentoWeb.Schema.ProductResponse

  action_fallback PentoWeb.FallbackController

  plug OpenApiSpex.Plug.CastAndValidate,
    json_render_error_v2: true,
    render_error: PentoWeb.Plug.CastErrorRenderer,
    replace_params: false

  @doc false
  def open_api_operation(action) do
    apply(__MODULE__, :"#{action}_operation", [])
  end

  def index_operation() do
    %Operation{
      tags: ["products"],
      summary: "Product list",
      operationId: "ProductController.index",
      responses: %{
        200 =>
          response(
            "Product list response",
            "application/json",
            ProductListResponse
          )
      }
    }
  end

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, :index, products: products)
  end

  def create_operation() do
    %Operation{
      tags: ["products"],
      summary: "Create product",
      operationId: "ProductController.create",
      requestBody:
        request_body(
          "Product params",
          %{"multipart/form-data" => [], "application/json" => [], "multipart/mixed" => []},
          CreateProductParams,
          required: true
        ),
      responses: %{
        201 =>
          response(
            "Product created Response",
            "application/json",
            ProductResponse
          )
      }
    }
  end

  def create(conn, _) do
    product_params = OpenApiSpex.body_params(conn)

    categories = Catalog.get_categories_by_names(product_params.categories)
    category_ids = Enum.map(categories, & &1.id)

    with {:ok, path} <- maybe_upload_static_file(product_params.image_upload),
         product_params =
           product_params
           |> Map.put(:image_upload, path)
           |> Map.put(:category_ids, category_ids),
         {:ok, %Product{} = product} <- Catalog.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/products/#{product}")
      |> render(:show, product: product)
    end
  end

  def show_operation do
    %Operation{
      tags: ["products"],
      summary: "Show product",
      operationId: "ProductController.show",
      parameters: [
        parameter(:id, :path, :integer, "Product ID", required: true)
      ],
      responses: %{
        200 =>
          response(
            "Product response",
            "application/json",
            ProductResponse
          ),
        404 =>
          response(
            "Product not found",
            "application/json",
            PentoWeb.Schema.ErrorResponse
          )
      }
    }
  end

  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, :show, product: product)
  end

  def update_operation do
    %Operation{
      tags: ["products"],
      summary: "Update product",
      operationId: "ProductController.update",
      parameters: [
        parameter(:id, :path, :integer, "Product ID", required: true)
      ],
      requestBody:
        request_body(
          "Product params",
          %{"multipart/form-data" => [], "application/json" => [], "multipart/mixed" => []},
          UpdateProductParams,
          required: true
        ),
      responses: %{
        200 =>
          response(
            "Updated Product response",
            "application/json",
            ProductResponse
          ),
        404 =>
          response(
            "Product not found",
            "application/json",
            PentoWeb.Schema.ErrorResponse
          )
      }
    }
  end

  def update(conn, %{"id" => id}) do
    product_params = OpenApiSpex.body_params(conn)
    product = Catalog.get_product!(id)
    categories = Catalog.get_categories_by_names(product_params.categories)
    category_ids = Enum.map(categories, & &1.id)

    with {:ok, path} <- maybe_upload_static_file(product_params.image_upload),
         product_params =
           product_params
           |> Map.put(:image_upload, path)
           |> Map.put(:category_ids, category_ids),
         {:ok, %Product{} = product} <- Catalog.update_product(product, product_params) do
      render(conn, :show, product: product)
    end
  end

  def delete_operation do
    %Operation{
      tags: ["products"],
      summary: "Delete product",
      operationId: "ProductController.delete",
      parameters: [
        parameter(:id, :path, :integer, "Product ID", required: true)
      ],
      responses: %{
        204 =>
          response(
            "Product deleted",
            "application/json",
            nil
          ),
        404 =>
          response(
            "Product not found",
            "application/json",
            PentoWeb.Schema.ErrorResponse
          )
      }
    }
  end

  def delete(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)

    with {:ok, %Product{}} <- Catalog.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end

  defp maybe_upload_static_file(%{path: path}) do
    # Plug in your production image file persistence implementation here!
    filename = Path.basename(path)
    dest = Path.join("priv/static/images", filename)
    File.cp!(path, dest)

    {:ok, ~p"/images/#{filename}"}
  end

  defp maybe_upload_static_file(nil), do: {:ok, nil}
  defp maybe_upload_static_file(""), do: {:ok, nil}
end
