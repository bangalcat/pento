defmodule Pento.Game.Board do
  alias Pento.Game.Pentomino
  alias Pento.Game.Shape

  defstruct active_pento: nil,
            completed_pentos: [],
            palette: [],
            points: []

  def puzzles() do
    ~w[default wide widest medium tiny]a
  end

  @doc """

  ## Examples

      iex> Board.new(:small, [{1, 1}, {1, 2}, {1, 3}])
      %Board{
        active_pento: nil,
        completed_pentos: [],
        palette: [:u, :v, :p],
        points: [{1, 1}, {1, 2}, {1, 3}]
      }

  """
  def new(palette, points) do
    %__MODULE__{
      palette: palette(palette),
      points: points
    }
  end

  def new(:tiny), do: new(:small, rect(5, 3))
  def new(:widest), do: new(:all, rect(20, 3))
  def new(:wide), do: new(:all, rect(15, 4))
  def new(:medium), do: new(:all, rect(12, 5))
  def new(:default), do: new(:all, rect(10, 6))

  def new(:skewed_widest), do: new(:all, skewed_rect(20, 3))
  def new(:skewed_wide), do: new(:all, skewed_rect(15, 4))
  def new(:skewed_medium), do: new(:all, skewed_rect(12, 5))
  def new(:skewed_default), do: new(:all, skewed_rect(10, 6))

  defp rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  defp skewed_rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x + y - 1, y}
  end

  defp palette(:all), do: [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  defp palette(:small), do: [:u, :v, :p]

  def to_shape(board) do
    Shape.__struct__(color: :purple, name: :board, points: board.points)
  end

  def to_shapes(board) do
    board_shape = to_shape(board)

    pento_shapes =
      [board.active_pento | board.completed_pentos]
      |> Enum.reverse()
      |> Enum.filter(& &1)
      |> Enum.map(&Pentomino.to_shape/1)

    [board_shape | pento_shapes]
  end

  def active?(board, shape_name) when is_binary(shape_name) do
    active?(board, String.to_existing_atom(shape_name))
  end

  def active?(%{active_pento: %{name: shape_name}}, shape_name), do: true
  def active?(_board, _shape_name), do: false
end
