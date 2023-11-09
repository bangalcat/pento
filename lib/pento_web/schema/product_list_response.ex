defmodule PentoWeb.Schema.ProductListResponse do
  use OpenApiSpex.Schemax
  alias PentoWeb.Schema.Product

  schema do
    property :data, :array, items: Product
    additional_properties false
  end
end
