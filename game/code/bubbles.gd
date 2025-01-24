extends Node2D


var bubbles: Dictionary = {}
@export var width = 64
@export var height = 64

func _ready() -> void:
	for x in width:
		for y in height:
			var pos := Vector2i(x, y)
			var bubble := Bubble.create(pos)
			bubbles[pos] = bubble
			add_child(bubble)
	
