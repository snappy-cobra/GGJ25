extends Node
class_name GameLogic

var scores: Dictionary = {}
var inactive: Dictionary = {}
var punishments: Dictionary = {}
var value_grid
var rand: RandomNumberGenerator = RandomNumberGenerator.new()
var pop: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 

func _on_bubble_tapped(bubble: Bubble, player: Player) -> void:
	var popped = bubble_tapped(bubble, player)
	if (popped):
		popped(bubble.value, player)

func player_added(id: String) -> void:
	
	print("Score init for team " + id)
	scores[id] = 0
		

func tapped(bubble: Bubble, player: Player, bubCallback: Callable) -> void:
	pop = bubCallback
	var popped = bubble_tapped(bubble, player)
	if (popped):
		popped(bubble.value, player)
		
func bubble_tapped(bubble: Bubble, player: Player) -> bool:
	if bubble.popped_by != null:
		# punish the player who tapped too late?
		# respond with corresponding sound/animation 
		return false
	print( str(bubble.pos.x)+ ":"+ str(bubble.pos.y) +" tapped!")
	bubble.taps += 1
	player_tapped(player)
	if bubble.taps >= bubble.taps_max:
		return true
	return false

func player_tapped(player: Player) -> void:
	#inactive[player] = 0
	pass
	
func popped(value: int, player: Player) -> void:
	add_score(get_score_for(value), player.team.id)
	pop.call(player)
	pass
	
func get_score_for(base_taps: int) -> int:
	return base_taps * base_taps
		
func add_score(value: int, teamId: String) -> void:
	scores[teamId] = scores.get(teamId, 0) + value
	print("Added score for team " + teamId + "; new score = " + str(scores[teamId]))
	

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
	# state = State.R
	print("GameLogic:: Game finished!")
