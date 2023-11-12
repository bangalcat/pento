defmodule PentoWeb.Schema.ProductListResponse do
  use OpenApiSpex.Schemax
  alias PentoWeb.Schema.Product
  alias PentoWeb.Schema.Common.Cursor

  schema do
    property :data, :array, items: Product
    property :cursor, Cursor
    property :total, :integer, minimum: 0
    additional_properties false
  end
end
