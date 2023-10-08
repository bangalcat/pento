defmodule Pento.Catalog.Product.Query do
  import Ecto.Query
  alias Pento.Survey.Demographic
  alias Pento.Accounts.User
  alias Pento.Survey.Rating
  alias Pento.Catalog.Product

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

  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings()
    |> average_ratings()
  end

  defp join_ratings(query) do
    query
    |> join(:inner, [p], r in Rating, on: r.product_id == p.id)
  end

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars))})
  end

  def join_users(query \\ base()) do
    query
    |> join(:left, [p, r], u in User, on: r.user_id == u.id)
  end

  def join_demographics(query \\ base()) do
    query
    |> join(:left, [p, r, u, d], d in Demographic, on: d.user_id == u.id)
  end

  def filter_by_age_group(query \\ base(), filter, now) do
    query
    |> apply_age_group_filter(filter, now)
  end

  defp apply_age_group_filter(query, "18 and under", now) do
    birth_year = now.year - 18

    query
    |> where([p, r, u, d], d.year_of_birth >= ^birth_year)
  end

  defp apply_age_group_filter(query, "18 to 25", now) do
    birth_year_max = now.year - 18
    birth_year_min = now.year - 25

    query
    |> where(
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "25 to 35", now) do
    birth_year_max = now.year - 25
    birth_year_min = now.year - 35

    query
    |> where(
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "35 and up", now) do
    birth_year_max = now.year - 35

    query
    |> where([p, r, u, d], d.year_of_birth <= ^birth_year_max)
  end

  defp apply_age_group_filter(query, _filter, _now) do
    query
  end

  def with_zero_ratings(query \\ base()) do
    query
    |> select([p], {p.name, 0})
  end
end
