defmodule PentoWeb.GameLive.Component do
  use Phoenix.Component
  import PentoWeb.GameLive.Colors

  alias Pento.Game

  @width 10

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :fill, :string
  attr :name, :string
  attr :"phx-click", :string
  attr :"phx-value", :string
  attr :"phx-target", :any

  def point(assigns) do
    ~H"""
    <use
      xlink:href="#point"
      x={convert(@x)}
      y={convert(@y)}
      fill={@fill}
      phx-click="pick"
      phx-value-name={@name}
      phx-target="#game"
    />
    """
  end

  defp convert(i) do
    (i - 1) * @width + 2 * @width
  end

  attr :view_box, :string
  slot :inner_block, required: true

  def canvas(assigns) do
    ~H"""
    <svg viewBox={@view_box}>
      <defs>
        <rect id="point" width="10" height="10" />
      </defs>
      <%= render_slot(@inner_block) %>
    </svg>
    """
  end

  attr :points, :list, required: true
  attr :name, :string, required: true
  attr :fill, :string, required: true

  def shape(assigns) do
    ~H"""
    <%= for {x, y} <- @points do %>
      <.point x={x} y={y} fill={@fill} name={@name} />
    <% end %>
    """
  end

  attr :shape_names, :list, required: true
  attr :completed_shape_names, :list, default: []

  def palette(assigns) do
    ~H"""
    <div id="palette">
      <.canvas view_box="0 0 500 125">
        <%= for shape <- palette_shapes(@shape_names) do %>
          <.shape
            points={shape.points}
            fill={color(shape.color, false, shape.name in @completed_shape_names)}
            name={shape.name}
          />
        <% end %>
      </.canvas>
    </div>
    """
  end

  defp palette_shapes(names) do
    names
    |> Enum.with_index()
    |> Enum.map(&place_pento/1)
  end

  defp place_pento({name, i}) do
    Game.new_pentomino(name: name, location: location(i))
    |> Game.pentomino_to_shape()
  end

  defp location(i) do
    x = rem(i, 6) * 4 + 3
    y = div(i, 6) * 5 + 3
    {x, y}
  end

  attr :view_box, :string, required: true
  slot :inner_block

  def control_pane(assigns) do
    ~H"""
    <svg viewBox={@view_box}>
      <defs>
        <polygon id="triangle" points="6.25 1.875, 12.5 12.5, 0 12.5" />
      </defs>
      <%= render_slot(@inner_block) %>
    </svg>
    """
  end

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :rotate, :integer, default: 0
  attr :fill, :string, required: true

  def triangle(assigns) do
    ~H"""
    <use x={@x} y={@y} transform={"rotate(#{@rotate} 100 100)"} href="#triangle" fill={@fill} />
    """
  end
end
