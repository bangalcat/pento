defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Pento.Survey.Rating
  alias Pento.Catalog.Category

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :image_upload, :string

    timestamps()

    has_many :ratings, Rating
    many_to_many :categories, Category, join_through: "product_categories"
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def decrease_price_changeset(product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_required([:unit_price])
    |> validate_number(:unit_price, greater_than: 0.0, less_than: product.unit_price)
  end

  def query_by_sku(sku) do
    from q in __MODULE__, where: q.sku == ^sku
  end
end
