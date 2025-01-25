extends Node2D

signal start(players: Array[Player])
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("start", game_start)
	
	pass # Replace with function body.
	
func game_start(players: Array[Player]) -> void:
	var width: int = 14
	var height: int = 8
	emit_signal("game_started", players, width, height)
	


func _on_tap(pos: Vector2i, player_id: String) -> void:
	if !%Players.has_player(player_id):
		%Players.player_join(player_id)
	var player = %Players.get_player(player_id)
	%Bubbles.pop(pos, player)

func _on_player_join(player_id: String) -> void:
	%Players.player_join(player_id)


func _on_player_leave(player_id: String) -> void:
	%Players.player_leave(player_id)
