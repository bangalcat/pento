defmodule PentoWeb.Schema.CreateProductParams do
  use OpenApiSpex.Schemax

  alias PentoWeb.Schema.Category

  @required [:name, :description, :unit_price, :sku]
  schema do
    write_only true
    property :name, :string
    property :description, :string
    property :unit_price, :number, minimum: 0.0, default: 0.0
    property :sku, :integer, minimum: 1
    property :image_upload, :string, format: :binary
    property :categories, :array, items: Category, default: []
    additional_properties false
    example example()
  end

  defp example do
    %{
      name: "Game 1",
      description: "Game 1 description",
      unit_price: 100.0,
      sku: 42,
      categories: ["Arcade"]
    }
  end
end
