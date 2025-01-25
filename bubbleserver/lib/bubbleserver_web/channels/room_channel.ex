defmodule BubbleserverWeb.RoomChannel do
  use BubbleserverWeb, :channel
  alias BubbleserverWeb.Presence
  require Logger

  @impl true
  def join("godot", %{"host" => "godot"}, socket) do
    IO.inspect("Godot is joining!")
    {:ok, socket}
  end

  def join("godot", payload, socket) do
    Logger.debug("Another player is joining")
    Logger.debug(inspect(payload))
    # if authorized?(payload) do
    # my_player_id = GameState.player_join()
    # socket = assign(socket, :player_id, my_player_id)
    send(self(), :after_join)
    # send(self(), :after_join)
    {:ok, socket.assigns.player_id, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end
  end

  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.player_id, %{
        online_at: inspect(System.system_time(:second))
      })

    presence_state = Presence.list(socket)
    push(socket, "presence_state", presence_state)
    Logger.debug(inspect(presence_state))
    {:noreply, socket}
  end

  @impl true
  def handle_in(event, data, socket) do
    Logger.debug("Handling event #{inspect(event)} with data #{inspect(data)}")
    if Map.has_key?(socket.assigns, :player_id) do
      data = Map.put(data, :player_id, socket.assigns.player_id)
      Logger.debug(inspect(data))
      broadcast!(socket, event, data)
    else
      broadcast!(socket, event, data)
    end
    {:noreply, socket}
  end
  # def handle_in("pop", %{"x" => x, "y" => y}, socket) do
  #   broadcast!(socket, "pop", %{player_id: socket.assigns.player_id, x: x, y: y})
  #   {:reply, {:ok, "Popped!"}, socket}
  # end

  # def handle_in("game_state", state, socket) do
  #   broadcast!(socket, "game_state", state)
  #   {:reply, {:ok, "aaa"}, socket}
  # end

  # # Channels can be used in a request/response fashion
  # # by sending replies to requests from the client
  # @impl true
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # # It is also common to receive messages from the client and
  # # broadcast to everyone in the current topic (room:lobby).
  # @impl true
  # def handle_in("shout", payload, socket) do
  #   broadcast(socket, "shout", payload)
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
