defmodule Pento.Catalog do
  @moduledoc """
  The Catalog context.
  """
  import Ecto.Query, warn: false
  alias Pento.Catalog.Search
  alias Pento.Catalog.Product
  alias Pento.Catalog.Category
  alias Pento.Repo

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Product |> Repo.all() |> Repo.preload(:categories)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Product |> Repo.get!(id) |> Repo.preload(:categories)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> change_product(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> change_product(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    categories = list_categories_by_id(attrs[:category_ids])

    product
    |> Repo.preload(:categories)
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:categories, categories)
  end

  defp list_categories_by_id(nil), do: []

  defp list_categories_by_id(category_ids) do
    Repo.all(from c in Category, where: c.id in ^category_ids)
  end

  def markdown_product(product, amount) do
    product
    |> Product.decrease_price_changeset(%{unit_price: product.price - amount})
    |> Repo.update()
  end

  alias Pento.Catalog.Faq

  @doc """
  Returns the list of faqs.

  ## Examples

      iex> list_faqs()
      [%Faq{}, ...]

  """
  def list_faqs do
    Repo.all(Faq)
  end

  @doc """
  Gets a single faq.

  Raises `Ecto.NoResultsError` if the Faq does not exist.

  ## Examples

      iex> get_faq!(123)
      %Faq{}

      iex> get_faq!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq!(id), do: Repo.get!(Faq, id)

  @doc """
  Creates a faq.

  ## Examples

      iex> create_faq(%{field: value})
      {:ok, %Faq{}}

      iex> create_faq(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_faq(attrs \\ %{}) do
    %Faq{}
    |> Faq.create_changeset(attrs)
    |> Repo.insert()
  end

  def upvote_faq(%Faq{} = faq, amount \\ 1) do
    faq
    |> Faq.upvote_changeset(%{vote: faq.vote + amount})
    |> Repo.update()
  end

  @doc """
  Updates a faq.

  ## Examples

      iex> update_faq(faq, %{field: new_value})
      {:ok, %Faq{}}

      iex> update_faq(faq, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_faq(%Faq{} = faq, attrs) do
    faq
    |> Faq.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a faq.

  ## Examples

      iex> delete_faq(faq)
      {:ok, %Faq{}}

      iex> delete_faq(faq)
      {:error, %Ecto.Changeset{}}

  """
  def delete_faq(%Faq{} = faq) do
    Repo.delete(faq)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking faq changes.

  ## Examples

      iex> change_faq(faq)
      %Ecto.Changeset{data: %Faq{}}

  """
  def change_faq(%Faq{} = faq, attrs \\ %{}) do
    Faq.changeset(faq, attrs)
  end

  def change_search(%Search{} = search, attrs \\ %{}) do
    Search.changeset(search, attrs)
  end

  def apply_search(search, attrs) do
    search
    |> change_search(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end

  def search_product(%Search{} = search) do
    search.sku
    |> Product.query_by_sku()
    |> Repo.all()
  end

  def list_products_with_user_rating(user) do
    Product.Query.with_user_ratings(user)
    |> Repo.all()
  end

  def products_with_average_ratings(%{
        age_group_filter: age_group_filter,
        gender_filter: gender_filter
      }) do
    Product.Query.with_average_ratings()
    |> Product.Query.join_users()
    |> Product.Query.join_demographics()
    |> Product.Query.filter_by_age_group(age_group_filter, DateTime.utc_now())
    |> Product.Query.filter_by_gender(gender_filter)
    |> Repo.all()
  end

  def products_with_zero_ratings() do
    Product.Query.with_zero_ratings()
    |> Repo.all()
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_cateogries_by_names(names) do
    from(c in Category, where: c.title in ^names)
    |> Repo.all()
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
