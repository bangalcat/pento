defmodule PentoWeb.GameLive.Board do
  use PentoWeb, :live_component

  import PentoWeb.GameLive.Colors
  import PentoWeb.GameLive.Component

  alias Pento.Game

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok, socket |> assign_params(id, puzzle) |> assign_board() |> assign_shapes()}
  end

  def render(assigns) do
    ~H"""
    <div id={@id} phx-window-keydown="key" phx-target={@myself} phx-hook="PreventSpaceScroll">
      <.canvas view_box="0 0 200 120">
        <%= for shape <- @shapes do %>
          <.shape
            points={shape.points}
            fill={color(shape.color, Game.active_board?(@board, shape.name), false)}
            name={shape.name}
          />
        <% end %>
      </.canvas>
      <hr />
      <.palette
        shape_names={@board.palette}
        completed_shape_names={Enum.map(@board.completed_pentos, & &1.name)}
      />
    </div>
    """
  end

  def assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    _puzzles = Game.puzzles()

    board =
      puzzle
      |> String.to_existing_atom()
      |> Game.new_board()

    assign(socket, board: board)
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shapes = board |> Game.board_to_shapes()
    assign(socket, shapes: shapes)
  end

  def handle_event("pick", %{"name" => name}, socket) do
    {:noreply, socket |> pick(name) |> assign_shapes()}
  end

  def handle_event("key", %{"key" => key}, socket) do
    {:noreply, socket |> do_key(key) |> assign_shapes()}
  end

  def do_key(socket, key) do
    case key do
      " " -> drop(socket)
      "ArrowLeft" -> move(socket, :left)
      "ArrowRight" -> move(socket, :right)
      "ArrowUp" -> move(socket, :up)
      "ArrowDown" -> move(socket, :down)
      "Shift" -> move(socket, :rotate)
      "Enter" -> move(socket, :flip)
      "Space" -> drop(socket)
      _ -> socket
    end
  end

  def move(socket, move) do
    case Game.maybe_move(socket.assigns.board, move) do
      {:ok, board} -> assign(socket, board: board) |> assign_shapes()
      {:error, message} -> put_flash(socket, :info, message)
    end
  end

  defp drop(socket) do
    case Game.maybe_drop(socket.assigns.board) do
      {:ok, board} -> assign(socket, board: board) |> assign_shapes()
      {:error, message} -> put_flash(socket, :info, message)
    end
  end

  defp pick(socket, name) do
    shape_name = String.to_existing_atom(name)
    update(socket, :board, &Game.pick(&1, shape_name))
  end
end
