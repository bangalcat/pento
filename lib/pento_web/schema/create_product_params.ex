defmodule PentoWeb.Schema.CreateProductParams do
  use OpenApiSpex.Schemax

  @required [:name, :description, :unit_price]
  schema do
    property :name, :string
    property :description, :string
    property :unit_price, :number
    property :sku, :integer
    property :image_upload, :string, format: :binary
    additional_properties false
  end
end
