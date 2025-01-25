defmodule GameState do
  use GenServer
  require Logger

  @type player_id :: non_neg_integer()

  @doc """
  The state as tracked by Elixir.
  """
  defstruct players: %{}

  # --- Public functions:
  @spec player_join() :: player_id()
  def player_join() do
    GenServer.call(__MODULE__, :player_join)
  end

  @spec player_left(player_id :: player_id()) :: :ok
  def player_left(player_id) do
    GenServer.cast(__MODULE__, {:player_left, player_id})
  end

  # --- GenServer internal callbacks:

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.debug("GameState server started up!")
    initial_state = %__MODULE__{}
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:player_join, _from, state) do
    player_id = to_string(map_size(state.players))
    state = update_in(state.players, &Map.put_new(&1, player_id, %{}))
    Logger.debug("GameState: Player #{player_id} added")
    Logger.debug(inspect(state))
    {:reply, player_id, state}
  end

  @impl true
  def handle_cast({:player_left, player_id}, state) do
    state = update_in(state.players, &Map.delete(&1, player_id))
    Logger.debug("GameState: Player #{player_id} left")
    Logger.debug(inspect(state))
    {:noreply, state}
  end
end
