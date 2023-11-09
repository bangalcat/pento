defmodule Pento.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Catalog` context.
  """

  @doc """
  Generate a unique product sku.
  """
  def unique_product_sku, do: System.unique_integer([:positive])

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "Some Name",
        description: "some description",
        unit_price: 120.5,
        sku: unique_product_sku()
      })
      |> Pento.Catalog.create_product()

    product
  end

  @doc """
  Generate a faq.
  """
  def faq_fixture(attrs \\ %{}) do
    {:ok, faq} =
      attrs
      |> Enum.into(%{
        question: "some question",
        answer: "some answer",
        vote: 42
      })
      |> Pento.Catalog.create_faq()

    faq
  end

  @doc """
  Generate a unique category title.
  """
  def unique_category_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        title: unique_category_title()
      })
      |> Pento.Catalog.create_category()

    category
  end
end
