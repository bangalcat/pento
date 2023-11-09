defmodule PentoWeb.Schema.CreateProductParams do
  use OpenApiSpex.Schemax

  @required [:name, :description, :unit_price]
  schema do
    property :name, :string
    property :description, :string
    property :unit_price, :number, minimum: 0.0
    property :sku, :integer
    property :image_upload, :string, format: :binary
    property :categories, :array, items: :string, default: []
    additional_properties false
  end
end
