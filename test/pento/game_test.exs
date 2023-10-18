defmodule Pento.GameTest do
  use ExUnit.Case

  alias Pento.Game.Board
  alias Pento.Game.Pentomino
  alias Pento.Game.Shape
  alias Pento.Game.Point

  doctest Point
  doctest Shape
  doctest Pentomino
  doctest Board

  describe "Game Board to shape" do
    test "it creates new board and convert to shapes, then there is only board shape" do
      board = Board.new(:tiny)

      assert [%Shape{color: :purple, name: :board}] = Board.to_shapes(board)
    end

    test "it has all correct board shape coords" do
      Board.new(:tiny) |> assert_has_all_coords(1..5, 1..3)
      Board.new(:wide) |> assert_has_all_coords(1..15, 1..4)
      Board.new(:widest) |> assert_has_all_coords(1..20, 1..3)
      Board.new(:medium) |> assert_has_all_coords(1..12, 1..5)
      Board.new(:default) |> assert_has_all_coords(1..10, 1..6)

      Board.new(:skewed_default) |> assert_has_all_coords_skewed(1..10, 1..6)
      Board.new(:skewed_medium) |> assert_has_all_coords_skewed(1..12, 1..5)
      Board.new(:skewed_wide) |> assert_has_all_coords_skewed(1..15, 1..4)
      Board.new(:skewed_widest) |> assert_has_all_coords_skewed(1..20, 1..3)
    end
  end

  defp assert_has_all_coords(board, xrange, yrange) do
    for x <- xrange, y <- yrange do
      assert {x, y} in board.points
    end
  end

  defp assert_has_all_coords_skewed(board, xrange, yrange) do
    for x <- xrange, y <- yrange do
      assert {x + y - 1, y} in board.points
    end
  end
end
