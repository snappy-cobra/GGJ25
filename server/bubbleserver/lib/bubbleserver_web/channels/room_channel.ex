defmodule BubbleserverWeb.RoomChannel do
  use BubbleserverWeb, :channel
  alias BubbleserverWeb.Presence

  @impl true
  def join("room:lobby", payload, socket) do
    # if authorized?(payload) do
      # my_player_id = GameState.player_join()
      # socket = assign(socket, :player_id, my_player_id)
      # send(self(), :after_join)
      send(self(), :after_join)
      {:ok, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end
  end

  def handle_info(:after_join, socket) do
    {:ok, _} =Presence.track(socket, socket.assigns.player_id, %{
      online_at: inspect(System.system_time(:second))
    })
    presence_state = Presence.list(socket)
    push(socket, "presence_state", presence_state)
    IO.inspect(presence_state)
    {:noreply, socket}
  end

  @impl true
  def handle_in("pop", %{}, socket) do
    {:reply, {:ok, "Popped!"}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
