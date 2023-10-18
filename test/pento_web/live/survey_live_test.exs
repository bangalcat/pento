defmodule PentoWeb.SurveyLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Demographic Form" do
    setup [:register_and_log_in_user]

    test "show demographic form when user has no demographic info", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/survey")

      assert html =~ "id\=\"demographic-form\""
      assert html =~ "Year of Birth"
      assert html =~ "Gender"
      assert html =~ "Education"
    end

    test "change demographic form and submit", %{conn: conn} do
      {:ok, liveview, _html} = live(conn, ~p"/survey")

      # open_browser(liveview)

      assert liveview
             |> form("#demographic-form", demographic: %{:gender => "prefer not to say"})
             |> render_change() =~ "prefer not to say"

      html =
        liveview
        |> form("#demographic-form",
          demographic: %{
            :gender => "other",
            :year_of_birth => 2000,
            :education => "graduate degree"
          }
        )
        |> render_submit()

      assert html =~ "Saving..."

      html = render(liveview)
      assert html =~ "Demographic created successfully"
      assert html =~ "other"
      assert html =~ "2000"
      assert html =~ "graduate degree"
      refute html =~ "<form"
    end
  end
end
