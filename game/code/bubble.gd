class_name Bubble
extends Node2D
const size = 16

var pos: Vector2i
var value: int
var taps: int
var taps_max: int
var popped_by: Player.Team

const bubble_scene = preload("res://scenes/bubble.tscn")
# @onready var logic: GameLogic = get_node("World/GameLogic")

static func create(pos: Vector2i, taps_required: int) -> Bubble:
	var bubble: Bubble = bubble_scene.instantiate()
	bubble.pos = pos
	bubble.position = pos * size
	
	if (pos.y % 2 == 1):
		bubble.position.x += 0.5 * size;
	bubble.setup(taps_required)	
	return bubble
	
func setup(taps_required: int):
	taps_max = taps_required
	value = taps_required
	

func pop(player: Player) -> void:
	$Unpopped.hide()
	$Popped.modulate = player.team.color
	taps = taps_max
	$Popped.show()
	
func score() -> int:
	return taps_max

func taps_left() -> int:
	return max(taps_max - taps, 0)

func _on_debug_input_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().get_root().get_node("World")._on_tap(pos, "debug_player_"+str(event.button_index))

func view_json() -> Array[int]:
	var view: Dictionary = {"taps": taps, "taps_max": taps_max}
	if popped_by != null:
		return [0, popped_by.id]
	else:
		return [taps_left(), score()]
	
