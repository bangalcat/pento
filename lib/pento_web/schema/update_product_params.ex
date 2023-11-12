defmodule PentoWeb.Schema.UpdateProductParams do
  use OpenApiSpex.Schemax

  schema do
    write_only true
    property :name, :string
    property :description, :string
    property :unit_price, :number
    property :sku, :integer
    property :image_upload, :string, format: :binary
    property :categories, :array, items: PentoWeb.Schema.Category, default: []
    additional_properties false
  end
end
