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
	
func _on_game_logic_game_started(grid: Array) -> void:
	var width = grid[0].size()
	var height = grid.size()
	size = Vector2i(width, height)
	for x in width:
		for y in height:
			var pos := Vector2(x, y)
			var bubble := Bubble.create(pos, grid[y][x])
			bubbles[pos] = bubble
			add_child(bubble)
	
func pop(pos: Vector2i, player: Player) -> void:
	prints("pop", pop, player)
	if bubbles.has(pos):
		bubbles[pos].pop(player)


func view_json() -> Dictionary:
	var bubble_data: Array[Bubble] = []
	for y in size.x:
		for x in size.y:
			var bubble: Bubble = bubbles[Vector2i(x, y)]
			bubble_data.append(bubble.view_json())
	return {"size": [size.x, size.y], "bubbles": bubble_data}
