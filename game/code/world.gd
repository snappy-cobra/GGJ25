extends Node2D

signal start()

enum State {LOBBY, RUNNING}
var state: State = State.LOBBY
var bubbles: Bubbles

func _ready() -> void:
	start_lobby()
	start_game()

func start_lobby() -> void:
	pass 
	
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
	print("Starting the game...")
	%Players.assign_teams()
	bubbles = Bubbles.create()
	add_child(bubbles)
	state = State.RUNNING
	%GameLogic.state_setter = set_state
	send_gamestate()
	start.emit()

func send_gamestate() -> void:
	if bubbles != null:
		$PhoenixInput.send_game_state(game_state_json())

func set_state(is_lobby: bool):
	if is_lobby:
		state = State.LOBBY
		bubbles.hide()
	else:
		state = State.RUNNING
		start_game()
		bubbles.show()

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
	send_gamestate()
