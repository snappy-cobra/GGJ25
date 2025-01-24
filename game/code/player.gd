class_name Player
extends Node

class Team:
	var id: String
	var color: Color
	func _init(id: String, color: Color):
		self.id = id
		self.color = color

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
