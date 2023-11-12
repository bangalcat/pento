defmodule PentoWeb.ProductJSON do
  alias Pento.Catalog.Product

  @doc """
  Renders a list of products.
  """
  def index(%{products: products, cursor: cursor, total: total}) do
    %{data: for(product <- products, do: data(product)), cursor: cursor, total: total}
  end

  @doc """
  Renders a single product.
  """
  def show(%{product: product}) do
    %{data: data(product)}
  end

  defp data(%Product{} = product) do
    %{
      id: product.id,
      name: product.name,
      description: product.description,
      unit_price: product.unit_price,
      sku: product.sku,
      image_upload: product.image_upload,
      categories: categories(product)
    }
  end

  defp categories(%Product{} = product) do
    for cat <- product.categories, do: cat.title
  end
end
