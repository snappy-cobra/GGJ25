class_name Bubble
extends Node2D
const size = 20

var pos: Vector2i
var value: int
var taps: int
var taps_max: int
var popped_by: Player.Team

@export
var picture: Array[Texture2D]

const bubble_scene = preload("res://scenes/bubble.tscn")

static func create(pos: Vector2i, taps_required: int, img_idx: int) -> Bubble:
	var bubble: Bubble = bubble_scene.instantiate()
	
	bubble.pos = pos
	bubble.position = pos * size

	
	if (pos.y % 2 == 1):
		bubble.position.x += 0.5 * size;
		
		
	bubble.get_node("Unpopped2").texture = bubble.picture[img_idx]
		
	bubble.setup(taps_required)	
	return bubble

	
func setup(taps_required: int):
	taps_max = taps_required
	value = taps_required
	update_taps()


func tap(player: Player) -> void:
	if taps < taps_max:
		taps += 1
		if taps >= taps_max:
			pop(player)
		else:
			get_tree().get_root().get_node("World").send_gamestate()
		update_taps()
	

func pop(player: Player) -> void:
	popped_by = player.team
	$Unpopped2.hide()
	$Popped2.modulate = player.team.color
	taps = taps_max
	$Popped2.show()
	
	if score() > 1:
		$Explosion.emitting = true
	else:
		$SmallPopParticles.emitting = true
	
	get_tree().get_root().get_node("World").get_node("GameLogic").add_score(score(), player.team.id)
	get_tree().get_root().get_node("World").send_gamestate()
	
func score() -> int:
	return taps_max

func taps_left() -> int:
	return max(taps_max - taps, 0)

func is_popped() -> bool:
	return taps_left() <= 0

func _on_debug_input_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().get_root().get_node("World")._on_tap(pos, "debug_player_"+str(event.button_index))

func view_json() -> Array[int]:
	var view: Dictionary = {"taps": taps, "taps_max": taps_max}
	if is_popped():
		return [0, popped_by.id]
	else:
		return [taps_left(), score()]
	#
#var fibonacciHash = function(int) {
  #const a = 2654435769 
  #const max32bit = 2147483647
   #return (int * a) % max32bit
#}

func update_taps() -> void:
	if taps_max > 1:
		%PopLabel.text = str(taps_left())
