defmodule Pento.Game do
  alias Pento.Game.Board
  alias Pento.Game.Pentomino

  @messages %{
    out_of_bounds: "Out of bounds!",
    illegal_drop: "Oops! You cannot drop out of bounds or on another piece"
  }

  def maybe_move(%{active_pento: p} = board, _m) when is_nil(p) do
    {:ok, board}
  end

  def maybe_move(board, move) do
    new_pento = move_fn(move).(board.active_pento)
    new_board = %{board | active_pento: new_pento}

    if Board.legal_move?(new_board) do
      {:ok, new_board}
    else
      {:error, @messages[:out_of_bounds]}
    end
  end

  defp move_fn(move) do
    case move do
      :up -> &Pentomino.up/1
      :down -> &Pentomino.down/1
      :left -> &Pentomino.left/1
      :right -> &Pentomino.right/1
      :flip -> &Pentomino.flip/1
      :rotate -> &Pentomino.rotate/1
    end
  end

  def maybe_drop(board) do
    if Board.legal_drop?(board) do
      {:ok, Board.drop(board)}
    else
      {:error, @messages[:illegal_drop]}
    end
  end

  def pick(board, shape_name) do
    Board.pick(board, shape_name)
  end

  def active_board?(board, shape_name) do
    Board.active?(board, shape_name)
  end

  defdelegate puzzles, to: Board

  defdelegate new_board(name), to: Board, as: :new

  def board_to_shapes(board) do
    Board.to_shapes(board)
  end

  def board_to_shape(board) do
    Board.to_shape(board)
  end

  def pentomino_to_shape(pentomino) do
    Pentomino.to_shape(pentomino)
  end

  defdelegate new_pentomino(fields \\ []), to: Pentomino, as: :new
end
