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
				weight = [Bubble.BOMB, Bubble.HOR].pick_random()#, Bubble.TOPLEFT, Bubble.TOPRIGHT].pick_random()
			var bubble_picture_idx = fibonacci_hash(y * size.y + x) >> 15
			var bubble := Bubble.create(pos, weight, bubble_picture_idx)
			bubbles[pos] = bubble
			add_child(bubble)

func tap(pos: Vector2i, player: Player) -> void:
	#prints("pop", pos, player)
	if bubbles.has(pos):
		var bubble: Bubble = bubbles[pos]
		bubbles[pos].tap(player)
		if bubble.is_popped():
			pop_effect(pos, player)


func pop_effect(pos: Vector2i, player: Player, flood: bool = true) -> void:
	
	var bubble: Bubble = bubbles[pos]
	for neighbour in neighbours(pos):
		if bubbles.has(neighbour) and !bubbles[neighbour].is_popped():
			if bubble.is_bomb():
				bubbles[neighbour].pop(player)
				pop_effect(neighbour, player, flood)
			if flood:
				for surrounded in check_fill(neighbour, player.team):
					bubbles[surrounded].pop(player)
					pop_effect(surrounded, player, false)
	if bubble.is_hor():
		for x in range(-2, 3):
			var n = Vector2i(pos.x + x, pos.y)
			if bubbles.has(n) and !bubbles[n].is_popped():
				bubbles[n].pop(player)
				pop_effect(n, player, flood)


func check_fill(start: Vector2i, team: Player.Team) -> Array[Vector2i]:
	var fringe: Array[Vector2i] = [start]
	var to_fill: Dictionary = {}
	while fringe.size() > 0:
		var pos: Vector2i = fringe.pop_back()
		if to_fill.has(pos):
			continue
		if !bubbles.has(pos):
			return []
		var bubble: Bubble = bubbles[pos]
		if bubble.is_popped():
			if bubble.popped_by == team:
				continue
			else:
				return []
		
		to_fill[pos] = true
		for neighbour: Vector2i in neighbours(pos):
			fringe.append(neighbour)
	# hack because generics is bad
	var r: Array[Vector2i] = []
	r.append_array(to_fill.keys())
	return r

func neighbours(pos: Vector2i) -> Array[Vector2i]:
	var n: Array[Vector2i] = [
		Vector2i(pos.x+1, pos.y),
		Vector2i(pos.x-1, pos.y),
		Vector2i(pos.x, pos.y+1),
		Vector2i(pos.x, pos.y-1)
	]
	if pos.y%2 == 0:
		n.append_array([Vector2i(pos.x-1, pos.y+1), Vector2i(pos.x-1, pos.y-1)])
	else:
		n.append_array([Vector2i(pos.x+1, pos.y+1), Vector2i(pos.x+1, pos.y-1)])
	return n

func view_json() -> Dictionary:
	var bubble_data: Array[Array] = []
	for y in size.y:
		for x in size.x:
			var bubble: Bubble = bubbles[Vector2i(x, y)]
			bubble_data.append(bubble.view_json())
	return {"size": [size.x, size.y], "bubbles": bubble_data}

func fibonacci_hash(num: int) -> int:
	const a = 40503
	const max32bit = 65536
	return (num * a) % max32bit
