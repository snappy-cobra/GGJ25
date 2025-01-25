extends Node
class_name GameLogic

signal tapped(bubble: Bubble, player: Player)
signal game_started()
signal game_over()

enum GameState { Lobby, Active } # game result is to be displayed on top in lobby UI 

var scores: Dictionary = {}
var inactive: Dictionary = {}
var punishments: Dictionary = {}
var state = GameState.Lobby
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("tapped", check_tap_popped)
	connect("game_started", started)
	connect("game_over", finished)
	pass # Replace with function body.

func started(players: Array, teams: Array) -> void:
	
	state = GameState.Active
	# fill the scores map with teams 
	# setup the board with actual values - generate some Rand()
	
	pass

func bubbleValue(base_taps: int) -> int:
	return base_taps * base_taps
	
func check_tap_popped(bubble: Bubble, player: Player) -> void:
	var popped = bubble_tapped(bubble, player)
	if (popped):
		popped(bubble.value, player)
		
func bubble_tapped(bubble: Bubble, player: Player) -> bool:
	if bubble.popped:
		# punish the player who tapped too late?
		# respond with corresponding sound/animation 
		return false
	bubble.taps += 1
	player_tapped(player)
	if bubble.taps >= bubble.taps_max:
		return true
	return false

func player_tapped(player: Player) -> void:
	inactive[player] = 0
	
	
func popped(value: int, player: Player) -> void:
	add_score(get_score_for(value), player.team)
	pass
	
func get_score_for(value: int) -> int:
	return value
	
func add_score(value: int, team: Player.Team) -> void:
	scores[team] = scores[team] + value
	
func finished() -> void:
	# update lobby UI with scores
	state = GameState.Lobby
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# punish non-tapping players
	for player in inactive.keys():
		inactive[player] = inactive[player] + delta
		var punishment: int = calc_punish_inactive(inactive[player], delta)
		punishments[player] = punishments[player] + punishment
		var score_to_subtract = floor(punishments[player])
		if score_to_subtract >= 1:
			punish(player, score_to_subtract)
	pass

func punish(player: Player, score_to_subtract: int ):
	#scores[]
	return 

func calc_punish_inactive(inactive_time: float, delta: float) -> int:
	return delta *(min(6, inactive_time) - 1) # grows very fast after 1 second of inactivity, up 5 per second 
