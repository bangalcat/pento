defmodule PentoWeb.RatingLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest

  import Pento.CatalogFixtures
  import Pento.SurveyFixtures

  alias PentoWeb.RatingLive.Index

  describe "Stateless" do
    setup [:register_and_log_in_user]

    test "no products exists", %{current_user: user} do
      assert render_component(&Index.product_list/1, products: [], user: user) =~
               "Ratings &#x2713;"
    end

    test "no rating exists products", %{current_user: user} do
      for i <- 1..5 do
        product_fixture(%{name: "game #{i}", unit_price: i})
      end

      products = Pento.Catalog.list_products_with_user_rating(user)

      assigns = %{products: products, current_user: user}

      rendered = render_component(&Index.product_list/1, assigns)
      refute rendered =~ "Ratings &#x2713;"
      assert rendered =~ "<form"
      assert rendered =~ "Save"
      assert rendered =~ "<select id=\"rating_stars\""
    end

    test "it renders correct rating details", %{current_user: user} do
      for i <- 1..5 do
        rating_fixture(%{user_id: user.id, stars: i})
      end

      products = Pento.Catalog.list_products_with_user_rating(user)
      assigns = %{products: products, current_user: user}

      rendered = render_component(&Index.product_list/1, assigns)
      assert rendered =~ "Ratings &#x2713;"
      refute rendered =~ "<form"
      refute rendered =~ "Save"
      assert rendered =~ "&#x2605;"
      assert rendered =~ "&#x2606;"
    end
  end
end
