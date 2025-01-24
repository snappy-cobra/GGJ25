defmodule BubbleserverWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :bubbleserver,
    pubsub_server: Bubbleserver.PubSub

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    for {player_id, metas} <- leaves do
      # Presence turns all IDs into strings;
      # let's make sure they are ints
      player_id = String.to_integer(player_id)
      GameState.player_left(player_id)
    end

    {:ok, state}
  end
end
