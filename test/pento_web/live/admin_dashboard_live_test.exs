defmodule PentoWeb.AdminDashboardLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pento.AccountsFixtures
  import Pento.CatalogFixtures
  import Pento.SurveyFixtures

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 42,
    unit_price: 120.5
  }
  @create_user_attrs %{
    username: "test",
    email: "test@test.com",
    password: "passwordpassword"
  }
  @create_user2_attrs %{
    username: "another-person",
    email: "another-person@email.com",
    password: "passwordpassword"
  }
  @create_user3_attrs %{
    username: "test2",
    email: "test2@test.com",
    password: "passwordpassword"
  }

  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 15,
    education: "high school"
  }

  describe "Survey Results" do
    setup [:register_and_log_in_user, :create_product, :create_user]

    setup %{user: user, product: product} do
      create_demographic(user)
      create_rating(2, user, product)

      user2 = user_fixture(@create_user2_attrs)
      create_demographic(user2)
      create_rating(3, user2, product)
    end

    test "it filters by age group", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/admin/dashboard")

      params = %{"age_group_filter" => "18 and under"}

      view
      |> element("#age-group-form")
      |> render_change(params) =~ "<title>2.00</title>"
    end

    test "it updates to display newly created ratings", %{conn: conn, product: product} do
      {:ok, view, html} = live(conn, "/admin/dashboard")
      assert html =~ "<title>2.50</title>"
      user3 = user_fixture(@create_user3_attrs)
      create_demographic(user3)
      create_rating(3, user3, product)

      send(view.pid, %{event: "rating_created"})
      :timer.sleep(2)
      assert render(view) =~ "<title>2.67</title>"
    end
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
    demographic = demographic_fixture(Map.merge(%{user_id: user.id}, @create_demographic_attrs))
    %{demographic: demographic}
  end
end
