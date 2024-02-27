defmodule BettingSystemWeb.GameChannelChannel do
  use Phoenix.Channel

  def join("game:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_round", payload, socket) do
    broadcast!(socket, "new_round", payload)
    {:noreply, socket}
  end

  def handle_in("end_game", payload, socket) do
    broadcast!(socket, "end_game", payload)
    {:noreply, socket}
  end
end
