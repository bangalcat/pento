defmodule PentoWeb.GameLive.GameInstructions do
  use Phoenix.Component

  @doc """
  show game instructions
  """
  def show(assigns) do
    ~H"""
    <p>
      This is Pento, a game where you try to fit pentominoes into a board.
    </p>
    """
  end
end
