extends Node2D

signal start(players: Array[Player], w: int, h: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_players_enough_players_joined(players: Array[Player]) -> void:
	
	print("Starting the game...")
	var width: int = 14
	var height: int = 8
	start.emit(players, width, height)
	pass 
