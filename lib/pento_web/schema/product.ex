defmodule PentoWeb.Schema.Product do
  use OpenApiSpex.Schemax

  @required [:id]
  schema "Product" do
    property :id, :integer
    property :name, :string
    property :description, :string
    property :unit_price, :number
    property :sku, :integer
    property :image_upload, :string, nullable: true
    property :created_at, :string
    property :updated_at, :string
    additional_properties false
  end
end
