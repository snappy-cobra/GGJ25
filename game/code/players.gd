class_name Players
extends Node


signal enough_players_joined(players: Array[Player])

var teams: Array[Player.Team] = [
	Player.Team.new(0, Color(1, 0, 0)),
	# Player.Team.new(1, Color(0, 1, 0)),
	Player.Team.new(2, Color(0, 0, 1))
]
var next_team: int = 0


func player_join(id: String) -> String:
	if has_node(id):
		return "Player %s already exists" % id
	var player_id_num = int(id)
	var player: Player = Player.create(id, id, teams[player_id_num % teams.size()]) #, teams[next_team]) assign teams when game starts
	# next_team = (next_team + 1) % teams.size()
	add_child(player)
	%GameLogic.player_added(id)
	#if check_full():
		#assign_teams(2)
		#print("Enough players!")
		#enough_players_joined.emit(players)
		##World.start.emit(all_players())
		## different return value?
	return ""

func check_full() -> bool:
	return get_child_count() >= 2
	
func player_leave(id: String) -> String:
	if !has_node(id):
		return "unknown player %s" % id
	var player: Player = get_node(id)
	player.queue_free()
	return ""

func has_player(id) -> bool:
	return has_node(id)

func get_player(id) -> Player:
	return get_node(id)
	
	
func assign_teams(preferredTeamsNumber: int = 2) -> void:
	var i: int = 0
	for p in get_children():
		p.team = teams[i % teams.size()]
		i += 1
