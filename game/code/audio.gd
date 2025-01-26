extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
var rand_pops: AudioStreamRandomizer = AudioStreamRandomizer.new()


func _ready() -> void:
	
	var sound1 = preload("res://sounds/tap1.mp3")
	var sound2 = preload("res://sounds/tap2.mp3")
	var sound3 = preload("res://sounds/tap3.mp3") 
	
	rand_pops.add_stream(0, sound1)
	rand_pops.add_stream(0, sound2)
	rand_pops.add_stream(0, sound3)
	var audio_player = %Audio
	audio_player.stream = rand_pops
	%Audio.play()
	#func load_mp3(path):
	#var file = FileAccess.open(path, FileAccess.READ)
	#var sound = AudioStreamMP3.new()
	#sound.data = file.get_buffer(file.get_length())
	 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if !$AudioStreamPlayer2D.is_playing():
	#	$AudioStreamPlayer2D.stream = CorrectSound
	#	$AudioStreamPlayer2D.play()
	rand_pops.instantiate_playback()
	pass

func _on_phoenix_input_tap(pos: Vector2i, player_id: String) -> void:
	var audio_player = %Audio
	audio_player.stream = rand_pops
	%Audio.play()
	
func _on_world_start() -> void:
	pass # Replace with function body.


func _on_timer_bar_game_over() -> void:
	pass # Replace with function body.




func _on_phoenix_input_player_join(player_id: String) -> void:
	pass # Replace with function body.
