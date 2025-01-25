extends Control

@onready var rect: ColorRect = $ColorRect

var round_time: float = 0 
var round_limit: float = 60 
var window_size = DisplayServer.window_get_size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect.set_size(Vector2(window_size.x, 50))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	round_time += delta
	if round_time >= round_limit:
		# signal round end
		return
	var percentage_remaining:float = (round_limit-round_time)/100
	# ends with 0 width
	rect.set_size(Vector2(floor(window_size.x * percentage_remaining), 50))
	
	# ends in the center
	# This does some JITTER now! 
	var x = (window_size.x - rect.get_size().x)/2
	x = floor(x)
	rect.set_position(Vector2(x, 0))
	pass
