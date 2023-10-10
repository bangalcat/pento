defmodule PentoWeb.SurveyResultsLiveTest do
  use PentoWeb.ConnCase

  import Pento.AccountsFixtures
  import Pento.CatalogFixtures
  import Pento.SurveyFixtures

  alias PentoWeb.Admin.SurveyResultsLive

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 42,
    unit_price: 120.5
  }
  @create_user2_attrs %{
    username: "test",
    email: "test@test.com",
    password: "passwordpassword"
  }
  @create_user_attrs %{
    username: "another-person",
    email: "another-person@email.com",
    password: "passwordpassword"
  }

  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 15,
    education: "high school"
  }
  @create_demographic2_attrs %{
    gender: "male",
    year_of_birth: DateTime.utc_now().year - 30,
    education: "other"
  }

  describe "Socket state" do
    setup [:create_user, :create_product, :create_socket, :register_and_log_in_user]

    setup %{user: user} do
      create_demographic(user)
      user2 = user_fixture(@create_user2_attrs)
      demographic_fixture(Map.merge(@create_demographic2_attrs, %{user_id: user2.id}))
      [user2: user2]
    end

    test "no ratings exist", %{socket: socket} do
      socket =
        socket
        |> SurveyResultsLive.assign_age_group_filter("all")
        |> SurveyResultsLive.assign_gender_filter("all")
        |> SurveyResultsLive.assign_products_with_average_ratings()

      assert socket.assigns.products_with_average_ratings == [{"Test Game", 0}]
    end

    test "ratings exist", %{socket: socket, product: product, user: user} do
      create_rating(2, user, product)

      socket =
        socket
        |> SurveyResultsLive.assign_age_group_filter("all")
        |> SurveyResultsLive.assign_gender_filter("all")
        |> SurveyResultsLive.assign_products_with_average_ratings()

      assert socket.assigns.products_with_average_ratings == [{"Test Game", 2.0}]
    end

    test "ratings are filtered by age group", %{
      socket: socket,
      user: user,
      product: product,
      user2: user2
    } do
      create_rating(2, user, product)
      create_rating(3, user2, product)

      socket
      |> SurveyResultsLive.assign_age_group_filter("all")
      |> assert_keys(:age_group_filter, "all")
      |> update_socket(:age_group_filter, nil)
      |> SurveyResultsLive.assign_age_group_filter("18 and under")
      |> assert_keys(:age_group_filter, "18 and under")
      |> SurveyResultsLive.assign_gender_filter("all")
      |> SurveyResultsLive.assign_products_with_average_ratings()
      |> assert_keys(:products_with_average_ratings, [{"Test Game", 2.0}])
    end
  end

  defp update_socket(socket, key, value) do
    %{socket | assigns: Map.merge(socket.assigns, Map.new([{key, value}]))}
  end

  defp create_product(_) do
    product = product_fixture(@create_product_attrs)
    %{product: product}
  end

  defp create_user(_) do
    user = user_fixture(@create_user_attrs)
    %{user: user}
  end

  defp create_rating(stars, user, product) do
    rating = rating_fixture(%{stars: stars, user_id: user.id, product_id: product.id})
    %{rating: rating}
  end

  defp create_demographic(user) do
    demographic = demographic_fixture(Map.merge(@create_demographic_attrs, %{user_id: user.id}))
    %{demographic: demographic}
  end

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  defp assert_keys(socket, key, value) do
    assert socket.assigns[key] == value
    socket
  end
end
