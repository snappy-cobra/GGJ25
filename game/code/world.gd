extends Node2D

signal start(players: Array[Player], w: int, h: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	pass # Replace with function body.
	


func _on_tap(pos: Vector2i, player_id: String) -> void:
	if !%Players.has_player(player_id):
		%Players.player_join(player_id)
	var player = %Players.get_player(player_id)
	%Bubbles.pop(pos, player)

func _on_player_join(player_id: String) -> void:
	%Players.player_join(player_id)


func _on_player_leave(player_id: String) -> void:
	%Players.player_leave(player_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_players_enough_players_joined(players: Array[Player]) -> void:
	
	print("Starting the game...")
	var width: int = 110
	var height: int = 60
	start.emit(players, width, height)
	pass 
