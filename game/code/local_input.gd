extends Node

const id0 := "local_0"
const id1 := "local_1"

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("join_0"):
		%Players.player_join(id0, "Local 0")
	if Input.is_action_just_pressed("leave_0"):
		%Players.player_leave(id0)
	%Players.player_move(id0, Input.get_vector("left_0", "right_0", "up_0", "down_0"))
	if Input.is_action_just_pressed("join_1"):
		%Players.player_join(id1, "Local 1")
	if Input.is_action_just_pressed("leave_1"):
		%Players.player_leave(id1)
	%Players.player_move(id1, Input.get_vector("left_1", "right_1", "up_1", "down_1"))
