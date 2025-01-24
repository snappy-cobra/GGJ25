defmodule GameState do
  use GenServer

  @doc """
  The state as tracked by Elixir.
  """
  defstruct players: %{}

  # --- Public functions:
  @spec player_join() :: non_neg_integer()
  def player_join() do
    GenServer.call(__MODULE__, :player_join)
  end

  # --- GenServer internal callbacks:

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.puts("GameState server started up!")
    initial_state = %__MODULE__{}
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:player_join, _from, state) do
    player_id = map_size(state.players)
    state = update_in(state.players, &Map.put_new(&1, player_id, %{}))
    {:reply, player_id, state}
  end
end
