defmodule PentoWeb.Schema.UpdateProductParams do
  use OpenApiSpex.Schemax

  schema do
    property :product, product()
    additional_properties false
  end

  embedded_schema :product do
    property :name, :string
    property :description, :string
    property :unit_price, :number
    property :sku, :integer
    property :image_upload, :string
    additional_properties false
  end
end
