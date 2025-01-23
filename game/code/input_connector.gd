extends Node

var socket = WebSocketPeer.new()

var has_introduced := false

func _ready() -> void:
	var connect_result := socket.connect_to_url("ws://localhost:2025")
	if connect_result != OK:
		quit("Failed to connect to host: " + str(connect_result), connect_result)

func _process(_delta: float) -> void:
	socket.poll()

	match socket.get_ready_state():
		WebSocketPeer.STATE_OPEN:
			if !has_introduced:
				socket.send_text(JSON.stringify({"type": "hostconnect", "password": "hunter2"}))
				has_introduced = true
			
			while socket.get_available_packet_count() > 0:
				var message_text: String = socket.get_packet().get_string_from_utf8()
				var message: Variant = JSON.parse_string(message_text)
				handle_message(message)
		WebSocketPeer.STATE_CLOSED:
			quit("Connection closed: " + socket.get_close_reason(), socket.get_close_code())


func handle_message(message: Variant) -> void:
	if !(message is Dictionary):
		return
	match message.type:
		"error":
			quit("Error: " + message.msg)
		"connectsuccess":
			pass
		"playerjoin":
			%Players.player_join(message.id, message.name)
		"playerleave":
			%Players.player_leave(message.id)
		"playerinput":
			match message.inputtype:
				"move":
					var movement := Vector2(message.movement[0], message.movement[1])
					%Players.player_move(message.id, movement)
				_:
					return
		_:
			return
func quit(error_message: String, error_code: int = -1):
	print(error_message)
	get_tree().quit(error_code)
