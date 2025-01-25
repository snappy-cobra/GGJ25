extends Control

@onready var rect: ColorRect = $ColorRect

signal game_over()

var round_time: float = 0 
var round_limit: float = 10 
var window_size = DisplayServer.window_get_size()
var is_tweening = false
var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_size = get_viewport_rect().size
	rect.set_size(Vector2(window_size.x, 50))
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
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	round_time += delta * 2
	if round_time >= round_limit:
		print("GAME OVER!")
		game_over.emit()
		set_process(false)
		return
	var factor_remaining:float = (round_limit-round_time) / 100
	
	_tween(lerp(1, 0, factor_remaining))
	
	# ends with 0 width
	rect.set_size(Vector2(floor(window_size.x * factor_remaining), 50))
	
	# ends in the center
	var x = floor((window_size.x - rect.get_size().x)/2)
	rect.set_position(Vector2(x, 0))
	pass
