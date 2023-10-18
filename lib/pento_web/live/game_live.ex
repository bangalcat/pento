defmodule PentoWeb.GameLive do
  use PentoWeb, :live_view

  alias PentoWeb.GameLive.Board
  alias PentoWeb.GameLive.GameInstructions

  def mount(%{"puzzle" => puzzle}, _session, socket) do
    {:ok, assign(socket, puzzle: puzzle)}
  end

  def render(assigns) do
    ~H"""
    <section class="container">
      <h1 class="font-heavy text-3xl">Welcome to Pento!</h1>
      <GameInstructions.show />
      <.live_component module={Board} puzzle={@puzzle} id="game" />
    </section>
    """
  end
end
