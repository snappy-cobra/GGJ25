class_name Bubbles
extends Node2D

var bubbles: Dictionary = {}
var size: Vector2i
const bubbles_scene = preload("res://scenes/bubbles.tscn")

static func create() -> Bubbles:
	var bubbles: Bubbles = bubbles_scene.instantiate()
	bubbles.setup_grid(Vector2i(50, 25))
	return bubbles

func setup_grid(size: Vector2i) -> void:
	var screen_middle = get_viewport_rect().size / 2
	
	self.position = Vector2i(screen_middle) + Vector2i(80, 50)
	
	self.size = size
	for y in size.y:
		for x in size.x:
			var pos := Vector2i(x, y)
			var weight: int = 1
			if randf() < 0.1:
				weight = randi_range(3, 8)
			var bubble := Bubble.create(pos, weight)
			bubbles[pos] = bubble
			add_child(bubble)
	
func pop(pos: Vector2i, player: Player) -> void:
	prints("pop", pop, player)
	if bubbles.has(pos):
		bubbles[pos].pop(player)


func view_json() -> Dictionary:
	var bubble_data: Array[Array] = []
	for y in size.y:
		for x in size.x:
			var bubble: Bubble = bubbles[Vector2i(x, y)]
			bubble_data.append(bubble.view_json())
	return {"size": [size.x, size.y], "bubbles": bubble_data}
