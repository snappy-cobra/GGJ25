extends Node
class_name GameLogic

var scores: Dictionary = {}
var pop: Callable #set from bubbles which has access to its bubble objects.... 
var state_setter: Callable
	
func get_score_for(base_taps: int) -> int:
	return base_taps * base_taps
		
func add_score(value: int, teamId: int) -> void:
	scores[teamId] = scores.get(teamId, 0) + value
	print("Added score for team " + str(teamId) + "; new score = " + str(scores[teamId]))

func _on_timer_bar_game_over() -> void:
	state_setter.call(true)
	print("GameLogic:: Game finished!")
	var scores_text: String = ""
	var winner = null
	var largest = 0
	for team in scores.keys():
		if scores[team] > largest:
			winner = str(team)
			largest = scores[team]
		scores_text = scores_text + "Team <" + str(team) + ">:"+ str(scores[team])+"\n"
		
	var final_score_text = "";
	if winner == null:
		final_score_text = "YOU'RE ALL LLOSERS.... "
	else:
		final_score_text = "Last WINNER: " + winner + "!"
		
	final_score_text = final_score_text + " Scores: \n" + scores_text
	
	%ScoreText.text = final_score_text
	# TODO  if debug
	%Timer.start()


func _on_timer_timeout() -> void:
	state_setter.call(false)
