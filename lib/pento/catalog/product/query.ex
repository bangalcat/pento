defmodule Pento.Catalog.Product.Query do
  alias Pento.Survey.Rating
  alias Pento.Catalog.Product
  import Ecto.Query

  def base do
    Product
  end

  def with_user_ratings(user) do
    base()
    |> preload_user_ratings(user)
  end

  def preload_user_ratings(query, user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end
end
