defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _sessions, socket) do
    {:ok,
     assign(socket, score: 0, message: "Make a guess:", number: random_number(), is_win: false)}
  end

  def handle_params(%{"restart" => "true"}, _uri, socket) do
    socket = assign(socket, is_win: false, number: random_number(), message: "Make a guess:")
    {:noreply, socket}
  end

  def handle_params(_, _uri, socket), do: {:noreply, socket}

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= time() %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <div class="my-10">
      <.link
        :if={@is_win}
        patch={~p"/guess?#{[restart: true]}"}
        class="bg-cyan-500 hover:bg-cyan-700 text-white font-bold py-2 px-4 rounded"
      >
        restart
      </.link>
    </div>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    {score, message, is_win} =
      if guess != "#{socket.assigns.number}" do
        message = "Your guess: #{guess}. Wrong. Guess again. "
        score = socket.assigns.score - 1
        {score, message, false}
      else
        message = "Your guess: #{guess}. That's correct! You win!"
        score = socket.assigns.score + 10
        {score, message, true}
      end

    {
      :noreply,
      assign(socket, message: message, score: score, is_win: is_win)
    }
  end

  def time do
    DateTime.utc_now() |> to_string()
  end

  defp random_number do
    Enum.random(1..10)
  end
end
