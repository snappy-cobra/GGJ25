class_name Player
extends Node

class Team:
	var id: int
	var color: Color
	func _init(id: int, color: Color):
		self.id = id
		self.color = color
	func view_json() -> Dictionary:
		return {"id": id, "color": color.to_html(false), "score": 0}

const player_scene = preload("res://scenes/player.tscn")
var id: String
var display_name: String
var team: Team

static func create(id: String, display_name: String, team: Team) -> Player:
	var player = player_scene.instantiate()
	player.id = id
	player.name = id
	player.display_name = display_name
	player.team = team
	return player

func set_color():
	$Outline.modulate = team.color
