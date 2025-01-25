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
	
