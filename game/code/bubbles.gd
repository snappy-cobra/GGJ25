extends Node2D

var bubbles: Dictionary = {}
var size: Vector2i

func _ready() -> void:
	setup_grid(Vector2i(100,50))

func setup_grid(size: Vector2i) -> void:
	self.size = size
	for x in size.x:
		for y in size.y:
			var pos := Vector2i(x, y)
			var bubble := Bubble.create(pos)
			bubbles[pos] = bubble
			add_child(bubble)
	
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
	for y in size.x:
		for x in size.y:
			var bubble: Bubble = bubbles[Vector2i(x, y)]
			bubble_data.append(bubble.view_json())
	return {"size": [size.x, size.y], "bubbles": bubble_data}
