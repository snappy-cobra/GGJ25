extends Node
class_name GameLogic

signal tapped(bubble: Bubble, player: Player)
signal game_started(value_grid: Array)
signal game_over()

enum GameState { Lobby, Active } # game result is to be displayed on top in lobby UI 

var scores: Dictionary = {}
var inactive: Dictionary = {}
var punishments: Dictionary = {}
var state = GameState.Lobby
var value_grid
var rand: RandomNumberGenerator = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# started([], 4, 3) testing
	pass # Replace with function body.

func _on_bubble_tapped(bubble: Bubble, player: Player) -> void:
	var popped = bubble_tapped(bubble, player)
	if (popped):
		popped(bubble.value, player)

func _on_world_start(players: Array[Player], grid_width: int, grid_height: int) -> void:
	print("GameLogic:: Game started!")
	scores = {}
	for p in players:
		scores[p] = 0
		
	state = GameState.Active
	
	# BUBBLE VALUES
	value_grid =  []
	for i in grid_height:
		value_grid.append([])
		for j in grid_width: 
			value_grid[i].append(rand.randi_range(3, 8))   
	
	# send it to the server
	game_started.emit(value_grid) # to json?
	pass
	
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
	add_score(get_score_for(value), player.team.id)
	pass
	
func get_score_for(base_taps: int) -> int:
	return base_taps * base_taps
		
func add_score(value: int, teamId: String) -> void:
	scores[teamId] = scores[teamId] + value
	
func finished() -> void:
	# update lobby UI with scores
	state = GameState.Lobby
	print("GameLogic:: Game finished!")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# punish non-tapping players
	# inactive_punish(delta)
	
	pass

func inactive_punish(delta: float):
	for player in inactive.keys():
		inactive[player] = inactive[player] + delta
		var punishment: int = calc_punish_inactive(inactive[player], delta)
		punishments[player] = punishments[player] + punishment
		var score_to_subtract = floor(punishments[player])
		if score_to_subtract >= 1:
			punish(player, score_to_subtract)
	
func punish(player: Player, score_to_subtract: int ):
	#scores[]
	return 

func calc_punish_inactive(inactive_time: float, delta: float) -> int:
	return delta *(min(6, inactive_time) - 1) # grows very fast after 1 second of inactivity, up 5 per second 


func _on_timer_bar_game_over() -> void:
	pass # Replace with function body.
