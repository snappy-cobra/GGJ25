class_name Bubble
extends Node2D
const size = 16

var pos: Vector2i

const bubble_scene = preload("res://scenes/bubble.tscn")

static func create(pos: Vector2i) -> Bubble:
	var bubble: Bubble = bubble_scene.instantiate()
	bubble.pos = pos
	bubble.position = pos * size
	return bubble
