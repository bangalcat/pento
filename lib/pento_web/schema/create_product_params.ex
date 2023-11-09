defmodule PentoWeb.Schema.CreateProductParams do
  use OpenApiSpex.Schemax

  @required [:name, :description, :unit_price, :sku]
  schema do
    write_only true
    property :name, :string
    property :description, :string
    property :unit_price, :number, minimum: 0.0, default: 0.0
    property :sku, :integer, minimum: 1
    property :image_upload, :string, format: :binary
    property :categories, :array, items: :string, default: []
    additional_properties false
  end
end
