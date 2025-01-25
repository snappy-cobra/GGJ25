class_name Players
extends Node


signal enough_players_joined(players: Array[Player])

var teams: Array[Player.Team] = [
	Player.Team.new("debug", Color(1, 0, 0)),
	Player.Team.new("GREEN", Color(0, 1, 0)),
	# Player.Team.new("BLUE", Color(0, 0, 1))
]
var next_team: int = 0
var debug_player: Player = Player.create("debug", "debug", Player.Team.new("debug", Color(1, 0, 1)))
var players: Array[Player] = [] 

class EmptyResult:
	var is_err: bool
	var err_msg: String
	static func ok() -> EmptyResult:
		var res := EmptyResult.new()
		res.is_err = false
		return res
	static func err(msg: String) -> EmptyResult:
		var res := EmptyResult.new()
		res.is_err = true
		res.err_msg = msg
		return res

func _ready() -> void:
	player_join(debug_player.id)
	player_join("2")

func player_join(id: String) -> EmptyResult:
	if has_node(id):
		return EmptyResult.err("Player %s already exists" % id)
	var player: Player = Player.create(id, id) #, teams[next_team]) assign teams when game starts
	# next_team = (next_team + 1) % teams.size()
	add_child(player)
	players.append(player)
	if check_full():
		assign_teams(2)
		print("Enough players!")
		enough_players_joined.emit(players)
		#World.start.emit(all_players())
		# different return value?
	return EmptyResult.ok()

func check_full() -> bool:
	return players.size() >= 2
	
func player_leave(id: String) -> EmptyResult:
	if !has_node(id):
		return EmptyResult.err("unknown player %s" % id)
	var player: Player = get_node(id)
	player.queue_free()
	return EmptyResult.ok()

func has_player(id) -> bool:
	return has_node(id)

func get_player(id) -> Player:
	return get_node(id)
	
	
func assign_teams(preferredTeamsNumber: int = 2) -> void:
	var i = 0
	for p in players:
		p.team = teams[i % preferredTeamsNumber]
		i = i+1
	
