defmodule PentoWeb.Schema.ProductListResponse do
  use OpenApiSpex.Schemax

  schema do
    property :data, :array, items: PentoWeb.Schema.Product
    additional_properties false
  end
end
