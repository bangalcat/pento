defmodule PentoWeb.Schema.ProductResponse do
  use OpenApiSpex.Schemax

  schema do
    property :data, PentoWeb.Schema.Product
    additional_properties false
  end
end
