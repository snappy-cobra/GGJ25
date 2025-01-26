extends Control

@onready var rect: ColorRect = $ColorRect

signal game_over()

var round_time: float = 0
var round_limit: float = (2*60+25) / 2 # The drop of the song is at 2:25
var window_size = DisplayServer.window_get_size()
var is_tweening = false
var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_size = get_viewport_rect().size
	rect.set_size(Vector2(window_size.x, 50)) 
	rotation = 0;
	var tween = create_tween()
	
	
	
	pass # Replace with function body.

func _tween(factor: float) -> void:
	if is_tweening == false:
		is_tweening = true
		tween = create_tween().set_loops()
		self.set_pivot_offset(Vector2(window_size.x / 2, 25))
		tween.tween_property(self, "rotation", 0.05, 1.0).set_ease(Tween.EASE_IN_OUT).set_delay(1)
		tween.chain().tween_property(self, "rotation", -0.05, 1.0).set_ease(Tween.EASE_IN_OUT).set_delay(1)
	else:
		tween.set_speed_scale((factor - 0.7) * 80.0)
		
func _process(delta: float) -> void:
	
	if round_time < 2:
		self.rotation = 0
	
	round_time += delta
	if round_time >= round_limit:
		print("GAME OVER!")
		game_over.emit()
		%Lobby.show()
		%BG2.hide()
		set_process(false)
		return
	var factor_remaining:float =  1-round_time/round_limit
	
	_tween(lerp(1, 0, factor_remaining))
	 
	
	_tween(lerp(1, 0, factor_remaining))
	
	# ends with 0 width
	rect.set_size(Vector2(floor(window_size.x * factor_remaining), 25))
	
	# ends in the center
	var x = floor((window_size.x - rect.get_size().x)/2)
	rect.set_position(Vector2(x, 0))
	
	rect.color.r = lerp(0, 1, 1/factor_remaining)
	rect.color.b = lerp(1, 0, factor_remaining)
	rect.color.g = lerp(1, 0, 1/factor_remaining)
	#%TextureProgressBar.tint_progress = rect.color 
	pass


func _on_world_start() -> void:
	print("Restarted timer")
	%Lobby.hide()
	%BG2.show()
	set_process(true)
	rotation = 0
	round_time = 0
	
	
	var bgm: AudioStreamPlayer = get_node("BGMusic")
	bgm.seek(0) # Restart song from the start
	bgm.playing = true
	
	pass # Replace with function body.
