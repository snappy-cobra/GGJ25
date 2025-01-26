extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
var rand_pops: AudioStreamRandomizer = AudioStreamRandomizer.new()
var join: AudioStreamRandomizer = AudioStreamRandomizer.new()


func _ready() -> void:
	pass
	#%Audio.play()
	#func load_mp3(path):
	#var file = FileAccess.open(path, FileAccess.READ)
	#var sound = AudioStreamMP3.new()
	#sound.data = file.get_buffer(file.get_length())
	 

func play_(path) -> void:
	var random: AudioStreamRandomizer = AudioStreamRandomizer.new()
	if path is Array:
		for s in path:
			var sound = load(s) 
			random.add_stream(0, sound)
		pass
	else:
		if path is String:
			var sound = load(path) 
			random.add_stream(0, sound)
		
	

	var audio_player = %Audio
	audio_player.stream = random
	%Audio.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if !$AudioStreamPlayer2D.is_playing():
	#	$AudioStreamPlayer2D.stream = CorrectSound
	#	$AudioStreamPlayer2D.play()
	
	#rand_pops.instantiate_playback()
	pass
func pop(value: int):
	if (value == 1):
		return
	var array = ["res://sound/explode_small.mp3"]
	for n in value:
		array.append("res://sound/explode_big.mp3")
		#array.append("res://sound/explode_big.mp3")
	play_(array) 
	for n in floor(value/2):
		play_(array) 
	
func _on_phoenix_input_tap(pos: Vector2i, player_id: String) -> void:
	play_(["res://sound/tap1.mp3", "res://sound/tap2.mp3", "res://sound/tap3.mp3"])
	  
func _on_world_start() -> void:
	play_("res://sound/task2_04.wav") 
	pass # Replace with function body.

func _on_timer_bar_game_over() -> void:
	play_("res://sound/gong.mp3")
	pass # Replace with function body.
