defmodule PentoWeb.Schema.Product do
  use OpenApiSpex.Schemax

  alias PentoWeb.Schema.Category

  @required [:id, :name, :unit_price, :sku]
  schema "Product" do
    property :id, :integer
    property :name, :string
    property :description, :string, nullable: true
    property :unit_price, :number, default: 0.0, minimum: 0.0
    property :sku, :integer
    property :ratings, :array, items: :integer, nullable: true

    property :categories, :array, items: Category
    property :image_upload, :string, format: :binary, nullable: true

    property :created_at, :string
    property :updated_at, :string
    additional_properties false
  end
end
