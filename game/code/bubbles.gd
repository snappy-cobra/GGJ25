extends Node2D

var bubbles: Dictionary = {}
@export var width = 64
@export var height = 64

func _ready() -> void:
	pass
	
func _on_game_logic_game_started(grid: Array) -> void:
	width = grid[0].size()
	height = grid.size()
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
	for y in height:
		for x in width:
			var bubble: Bubble = bubbles[Vector2i(x, y)]
			bubble_data.append(bubble.view_json())
	return {"size": [width, height], "bubbles": bubble_data}
