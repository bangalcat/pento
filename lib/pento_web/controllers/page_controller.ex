defmodule PentoWeb.PageController do
  use PentoWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: "/guess")
    else
      render(conn, :home, layout: false)
    end
  end
end
