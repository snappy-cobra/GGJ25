extends Node2D

signal start(players: Array[Player], w: int, h: int)

enum State {LOBBY, RUNNING}
var state: State = State.LOBBY
var bubbles: Bubbles

func _ready() -> void:
	# debug only; don't want to wait for players
	start_game()

	
func _on_tap(pos: Vector2i, player_id: String) -> void:
	if !%Players.has_player(player_id):
		_on_player_join(player_id)
	if state == State.RUNNING:
		var player = %Players.get_player(player_id)
		%GameLogic.tapped(bubbles.bubbles[pos], player, bubbles.bubbles[pos].pop)
	
func _on_player_join(player_id: String) -> void:
	%Players.player_join(player_id)
	if state == State.LOBBY && %Players.is_full():
		start_game()


func _on_player_leave(player_id: String) -> void:
	%Players.player_leave(player_id)

func start_game() -> void:
	%Players.assign_teams()
	bubbles = Bubbles.create()
	add_child(bubbles)
	state = State.RUNNING


func _on_players_enough_players_joined(players: Array[Player]) -> void:
	
	print("Starting the game...")
	var width: int = 110
	var height: int = 60
	start.emit(players, width, height)
	pass 

func game_state_json() -> Dictionary:
	if state == State.LOBBY:
		return {"state": "lobby"}
	elif state == State.RUNNING:
		return {
			"state": "running",
			"bubbles": bubbles.view_json(),
			 "teams": $Players.teams.map(func(team): return team.view_json())
		}
	else:
		assert(false)
		return {}

func _on_heartbeat_timeout() -> void:
	if bubbles != null:
		$PhoenixInput.send_game_state(game_state_json())
