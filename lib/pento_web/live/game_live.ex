defmodule PentoWeb.GameLive do
  use PentoWeb, :live_view

  alias PentoWeb.GameLive.Board
  alias PentoWeb.GameLive.GameInstructions
  import PentoWeb.GameLive.Component, only: [control_pane: 1, triangle: 1]

  def mount(%{"puzzle" => puzzle}, _session, socket) do
    {:ok, assign(socket, puzzle: puzzle)}
  end

  def render(assigns) do
    ~H"""
    <section class="container">
      <h1 class="font-heavy text-3xl">Welcome to Pento!</h1>
      <GameInstructions.show />
      <.live_component module={Board} puzzle={@puzzle} id="game" />
      <.control_pane view_box="0 0 200 40">
        <.triangle x={100} y={5} rotate={0} fill="#2a9b65" />
        <.triangle x={15} y={70} rotate={90} fill="#2a9b65" />
        <.triangle x={87} y={163} rotate={180} fill="#2a9b65" />
        <.triangle x={172} y={83} rotate={270} fill="#2a9b65" />
      </.control_pane>
    </section>
    """
  end
end
