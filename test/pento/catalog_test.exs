defmodule Pento.CatalogTest do
  use Pento.DataCase

  alias Pento.Catalog

  describe "products" do
    alias Pento.Catalog.Product

    import Pento.CatalogFixtures

    @invalid_attrs %{name: nil, description: nil, unit_price: nil, sku: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        unit_price: 120.5,
        sku: 42
      }

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.unit_price == 120.5
      assert product.sku == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        unit_price: 456.7,
        sku: 43
      }

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.unit_price == 456.7
      assert product.sku == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end

  describe "faqs" do
    alias Pento.Catalog.Faq

    import Pento.CatalogFixtures

    @invalid_attrs %{question: nil, answer: nil, vote: nil}

    test "list_faqs/0 returns all faqs" do
      faq = faq_fixture()
      assert Catalog.list_faqs() == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert Catalog.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      valid_attrs = %{question: "some question", answer: "some answer"}

      assert {:ok, %Faq{} = faq} = Catalog.create_faq(valid_attrs)
      assert faq.question == "some question"
      assert faq.answer == "some answer"
      assert faq.vote == 0
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      update_attrs = %{question: "some updated question", answer: "some updated answer", vote: 43}

      assert {:ok, %Faq{} = faq} = Catalog.update_faq(faq, update_attrs)
      assert faq.question == "some updated question"
      assert faq.answer == "some updated answer"
      assert faq.vote == 43
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_faq(faq, @invalid_attrs)
      assert faq == Catalog.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %Faq{}} = Catalog.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = Catalog.change_faq(faq)
    end
  end

  describe "categories" do
    alias Pento.Catalog.Category

    import Pento.CatalogFixtures

    @invalid_attrs %{title: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Catalog.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Catalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Category{} = category} = Catalog.create_category(valid_attrs)
      assert category.title == "some title"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Category{} = category} = Catalog.update_category(category, update_attrs)
      assert category.title == "some updated title"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_category(category, @invalid_attrs)
      assert category == Catalog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Catalog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Catalog.change_category(category)
    end
  end
end
