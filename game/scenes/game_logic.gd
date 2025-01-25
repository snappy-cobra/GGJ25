extends Node
class_name GameLogic

var scores: Dictionary = {}
var pop: Callable #set from bubbles which has access to its bubble objects.... 
var state_setter: Callable

func _on_bubble_tapped(bubble: Bubble, player: Player) -> void:
	var popped = bubble_tapped(bubble, player)
	if (popped):
		popped(bubble.value, player)

func tapped(bubble: Bubble, player: Player, bubCallback: Callable) -> void:
	pop = bubCallback
	var popped = bubble_tapped(bubble, player)
	if (popped):
		popped(bubble.value, player)
		
func bubble_tapped(bubble: Bubble, player: Player) -> bool: #true if POPPED 
	if bubble.popped_by != null:
		# special return value? 
		return false
	print( str(bubble.pos.x)+ ":"+ str(bubble.pos.y) +" tapped!")
	bubble.taps += 1
	if bubble.taps >= bubble.taps_max:
		return true
	return false
	
func popped(value: int, player: Player) -> void:
	add_score(get_score_for(value), player.team.id)
	pop.call(player)
	
func get_score_for(base_taps: int) -> int:
	return base_taps * base_taps
		
func add_score(value: int, teamId: int) -> void:
	scores[teamId] = scores.get(teamId, 0) + value
	print("Added score for team " + str(teamId) + "; new score = " + str(scores[teamId]))

func _on_timer_bar_game_over() -> void:
	state_setter.call(true)
	print("GameLogic:: Game finished!")
	%ScoreText.text = "Hi!" # + scores.values()[0]
	# TODO  if debug
	%Timer.start()


func _on_timer_timeout() -> void:
	state_setter.call(false)
