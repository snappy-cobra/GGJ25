extends Node2D

signal start()

enum State {LOBBY, RUNNING}
var state: State = State.LOBBY
var bubbles: Bubbles

func _ready() -> void:
	#reset_lobby()
	start_game()

func reset_lobby() -> void:
	%ScoreView.text = "No games have been played yet..."

		
func start_lobby() -> void:
	var teams = {}
	var team_names = []
	for p in %Players.get_children():
		if p.team.id not in teams:
			team_names.append(p.team.id)
			teams[p.team.id] = []
	for p in %Players.get_children():
		teams[p.team.id].append(p)
	
	var team_1 = teams.values()	[0]
	var team_2 = teams.values()	[1]
	%T1_P1.text = team_1[0].display_name
	%T2_P1.text = team_2[0].display_name
	
	%T1.text = str(team_names[0])
	%T2.text = str(team_names[1])
	
func _on_tap(pos: Vector2i, player_id: String) -> void:
	if !%Players.has_player(player_id):
		_on_player_join(player_id)
	if state == State.RUNNING:
		var player = %Players.get_player(player_id)
		bubbles.tap(pos, player)
		#%GameLogic.tapped(bubbles.bubbles[pos], player, bubbles.bubbles[pos].pop)
	
func _on_player_join(player_id: String) -> void:
	%Players.player_join(player_id)
	if state == State.LOBBY && %Players.check_full():
		start_game()
	update_team_labels()

func update_team_labels():
	var n1: int = 0
	var n2: int = 0
	for p in %Players.get_children():
		if p.team.id == 0:
			n1 = n1 +1
		else:
			n2 = n2 +1 
			
	%T1_P.text = "Player count: " + str(n1)
	%T2_P.text = "Player count: " + str(n2)
	
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
