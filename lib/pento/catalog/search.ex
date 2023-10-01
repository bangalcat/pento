defmodule Pento.Catalog.Search do
  defstruct [:sku]
  @types %{sku: :integer}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = search, attrs) do
    {search, @types}
    |> cast(attrs, [:sku])
    |> validate_number(:sku, greater_than_or_equal_to: 1_000_000)
  end
end
