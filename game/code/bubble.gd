class_name Bubble
extends Node2D
const size = 16

var pos: Vector2i
var value: int
var taps: int
var taps_max: int

const bubble_scene = preload("res://scenes/bubble.tscn")

static func create(pos: Vector2i) -> Bubble:
	var bubble: Bubble = bubble_scene.instantiate()
	bubble.pos = pos
	bubble.position = pos * size
	
	if (pos.y % 2 == 0):
		bubble.position.x += 0.5 * size;
	return bubble

func setup(taps_required: int):
	taps_max = taps_required
	value = taps_required
	
func tapped(player: Player) -> void:
	emit_signal("tapped", self, player) 
	
	
func pop(player: Player) -> void:
	$Unpopped.hide()
	$Popped.modulate = player.team.color
	$Popped.show()
	

func _on_debug_input_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		pop(get_node("../../Players").debug_player)
