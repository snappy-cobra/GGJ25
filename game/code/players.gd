extends Node2D

const player_scene = preload("res://scenes/player.tscn")

class EmptyResult:
	var is_err: bool
	var err_msg: String
	static func ok() -> EmptyResult:
		var res := EmptyResult.new()
		res.is_err = false
		return res
	static func err(msg: String) -> EmptyResult:
		var res := EmptyResult.new()
		res.is_err = true
		res.err_msg = msg
		return res

func player_join(id: String, name: String) -> EmptyResult:
	if has_node(id):
		return EmptyResult.err("Player %s already exists" % id)
	var player: Player = player_scene.instantiate()
	player.id = id
	player.name = id
	player.display_name = name
	player.position = Vector2(randf_range(100, 400), randf_range(100, 400))
	add_child(player)
	return EmptyResult.ok()

func player_leave(id: String) -> EmptyResult:
	if !has_node(id):
		return EmptyResult.err("unknown player %s" % id)
	var player: Player = get_node(id)
	player.queue_free()
	return EmptyResult.ok()

# can be used for generic input if needed
func player_move(id: String, movement: Vector2) -> EmptyResult:
	if !has_node(id):
		return EmptyResult.err("unknown player %s" % id)
	var player: Player = get_node(id)
	player.move(movement)
	return EmptyResult.ok()
	
