defmodule Pento.Game.Point do
  @doc """
  ## Examples

      iex> Point.new(1, 2)
      {1, 2}

  """
  def new(x, y) when is_integer(x) and is_integer(y), do: {x, y}

  @doc """
  ## Examples

      iex> Point.prepare({1, 2}, 0, false, {0, 0})
      {-2, -1}

      iex> Point.prepare({1, 2}, 90, false, {0, 0})
      {-1, 2}

      iex> Point.prepare({1, 2}, 180, false, {0, 0})
      {2, 1}

      iex> Point.prepare({1, 2}, 270, false, {0, 0})
      {1, -2}

      iex> Point.prepare({1, 2}, 0, true, {0, 0})
      {2, -1}
  """
  def prepare(point, rotation, reflected, location) do
    point
    |> rotate(rotation)
    |> maybe_reflect(reflected)
    |> move(location)
    |> center()
  end

  def move({x, y}, {change_x, change_y}) do
    {x + change_x, y + change_y}
  end

  def maybe_reflect(point, true), do: reflect(point)
  def maybe_reflect(point, false), do: point

  def transpose({x, y}), do: {y, x}

  def flip({x, y}), do: {x, 6 - y}

  def reflect({x, y}), do: {6 - x, y}

  def rotate(point, 0), do: point
  def rotate(point, 90), do: point |> reflect() |> transpose()
  def rotate(point, 180), do: point |> reflect() |> flip()
  def rotate(point, 270), do: point |> flip() |> transpose()

  def center(point), do: move(point, {-3, -3})
end
