class_name Player
extends CharacterBody2D

const speed = 50
var id: String
var display_name: String


func _physics_process(_delta: float) -> void:
	move_and_slide()

func move(movement: Vector2) -> void:
	velocity = movement.normalized() * speed
