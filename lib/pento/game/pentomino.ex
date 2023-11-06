defmodule Pento.Game.Pentomino do
  alias Pento.Game.Point
  alias Pento.Game.Shape

  @names [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  @default_location {8, 8}

  defstruct name: :i,
            rotation: 0,
            reflected: false,
            location: @default_location

  @doc """

  ## Examples

      iex> Pentomino.new()
      %Pentomino{
        location: {8, 8},
        name: :i,
        reflected: false,
        rotation: 0
      }

      iex> Pentomino.new(name: :x, location: {3, 3})
      %Pentomino{
        location: {3, 3},
        name: :x,
        reflected: false,
        rotation: 0
      }
  """
  def new(fields \\ []), do: __struct__(fields)

  def names, do: @names

  @doc """

  it only allows 0, 90, 270, 360 degrees

  ## Example

      iex> Pentomino.new() |> Pentomino.rotate()
      %Pentomino{
        location: {8, 8},
        name: :i,
        reflected: false,
        rotation: 90
      }

      iex> Pentomino.new(rotation: 270) |> Pentomino.rotate()
      %Pentomino{
        location: {8, 8},
        name: :i,
        reflected: false,
        rotation: 0
      }

      iex> Pentomino.new(rotation: 90) |> Pentomino.rotate(clockwise: false)
      %Pentomino{
        location: {8, 8},
        name: :i,
        reflected: false,
        rotation: 0
      }


  """
  def rotate(pentomino, opts \\ [])

  def rotate(%{rotation: degrees} = p, opts) do
    clockwise? = Keyword.get(opts, :clockwise, true)
    degree = if clockwise?, do: 90, else: 270
    %{p | rotation: rem(degrees + degree, 360)}
  end

  @doc """

  ## Example

      iex> Pentomino.new() |> Pentomino.flip()
      %Pentomino{
        location: {8, 8},
        name: :i,
        reflected: true,
        rotation: 0
      }

  """

  def flip(%{reflected: reflection} = p) do
    %{p | reflected: not reflection}
  end

  @doc """

  ## Example

      iex> Pentomino.new() |> Pentomino.up()
      %Pentomino{
        location: {8, 7},
        name: :i,
        reflected: false,
        rotation: 0
      }
  """

  def up(p) do
    %{p | location: Point.move(p.location, {0, -1})}
  end

  @doc """

  ## Example
      iex> Pentomino.new() |> Pentomino.down()
      %Pentomino{
        location: {8, 9},
        name: :i,
        reflected: false,
        rotation: 0
      }
  """
  def down(p) do
    %{p | location: Point.move(p.location, {0, 1})}
  end

  @doc """

  ## Example
      iex> Pentomino.new() |> Pentomino.left()
      %Pentomino{
        location: {7, 8},
        name: :i,
        reflected: false,
        rotation: 0
      }
  """
  def left(p) do
    %{p | location: Point.move(p.location, {-1, 0})}
  end

  @doc """

  ## Example
      iex> Pentomino.new() |> Pentomino.right()
      %Pentomino{
        location: {9, 8},
        name: :i,
        reflected: false,
        rotation: 0
      }
  """
  def right(p) do
    %{p | location: Point.move(p.location, {1, 0})}
  end

  @doc """

  ## Examples

      iex> Pentomino.new() |> Pentomino.to_shape()
      %Shape{
        color: :dark_green,
        name: :i,
        points: [{8, 6}, {8, 7}, {8, 8}, {8, 9}, {8, 10}]
      }

  """
  def to_shape(pento) do
    Shape.new(pento.name, pento.rotation, pento.reflected, pento.location)
  end

  def overlapping?(pento1, pento2) do
    {p1, p2} = {to_shape(pento1).points, to_shape(pento2).points}
    Enum.count(p1 -- p2) != 5
  end
end
