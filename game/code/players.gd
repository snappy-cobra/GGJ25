class_name Players
extends Node

var teams: Array[Player.Team] = [
	Player.Team.new(0, Color.CYAN),
	Player.Team.new(1, Color.MAGENTA)
]
var next_team: int = 0

func player_join(id: String) -> String:
	if has_node(id):
		return "Player %s already exists" % id
	var player: Player = Player.create(id, id, smallest_team())
	add_child(player)
	return ""

func smallest_team() -> Player.Team:
	# this is way more complicated than it should be, but I don't want 2 persistent states
	var ppt = {}
	for team in teams:
		ppt[team] = 0
	for player in get_children():
		ppt[player.team] += 1
	var least_players = 1_000_000_000
	var smallest: Player.Team = null
	var rteams = teams.duplicate()
	rteams.shuffle()
	for team in rteams:
		if ppt[team] < least_players:
			smallest = team
			least_players = ppt[team]
	assert(smallest != null)
	return smallest


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
	var players = get_children()
	players.shuffle()
	for p in players:
		p.team = teams[i % teams.size()]
		i += 1

func show_player(id: String, viewpos: Vector2) -> void:
	#prints("player", id, viewpos)
	if !has_player(id):
		return
	var player = get_player(id)
	player.visible = true
	player.set_color()
	player.position = get_viewport().get_visible_rect().size * (viewpos+Vector2(0, 0.12)) * Vector2(0.9, 0.8)

func hide_players():
	for player in get_children():
		player.visible = false


func view_json() -> Dictionary:
	var players = {}
	for player in get_children():
		players[player.id] = {"team": player.team.id}
	return players
