class_name Bubbles
extends Node2D

var bubbles: Dictionary = {}
var size: Vector2i
const bubbles_scene = preload("res://scenes/bubbles.tscn")

static func create() -> Bubbles:
	var bubbles: Bubbles = bubbles_scene.instantiate()
	bubbles.setup_grid(Vector2i(100, 50))
	return bubbles

func setup_grid(size: Vector2i) -> void:
	self.size = size
	for x in size.x:
		for y in size.y:
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
	for x in size.x:
		for y in size.y:
			var bubble: Bubble = bubbles[Vector2i(x, y)]
			bubble_data.append(bubble.view_json())
	return {"size": [size.x, size.y], "bubbles": bubble_data}
