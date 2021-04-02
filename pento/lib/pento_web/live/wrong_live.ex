defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    number = :rand.uniform(10)

    {
      :ok,
      assign(
        socket,
        score: 0,
        time: time(),
        won: false,
        message: "Guess a number.",
        number: number
      )
    }
  end

  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= if @won do %>
    <%= live_patch to: Routes.live_path(PentoWeb.Endpoint, PentoWeb.WrongLive) do %>
          Play again
        <% end %>
      <% else %>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
        <% end %>
      <% end %>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end

  def handle_event(
        "guess",
        %{"number" => guess} = data,
        %{assigns: %{number: number, score: score}} = socket
      ) do
    IO.inspect(socket)
    IO.inspect(data)

    {guess_integer, _} = Integer.parse(guess)

    if guess_integer == number do
      message = "You guessed correctly! Congratulations"
      score = score + 5
      {:noreply, assign(socket, message: message, score: score, won: true)}
    else
      message = "Your guess: #{guess}. Wrong. Guess again. "
      score = score - 1
      {:noreply, assign(socket, message: message, score: score)}
    end
  end

  def handle_params(_params, _, socket) do
    number = :rand.uniform(10)
    {:noreply, assign(socket, won: false, number: number)}
  end
end
