extends Node

signal tap(pos: Vector2i, player_id: String)
signal player_join(player_id: String)
signal player_leave(player_id: String)

var socket : PhoenixSocket
var channel : PhoenixChannel
var presence : PhoenixPresence

func _ready() -> void:
	
	if Config.is_local():
		queue_free()
		return
	socket = PhoenixSocket.new(Config.server_url(), {params = {"host": "godot"}})

	# Subscribe to Socket events
	socket.on_open.connect(_on_Socket_open)
	socket.on_close.connect(_on_Socket_close)
	socket.on_error.connect(_on_Socket_error)
	socket.on_connecting.connect(_on_Socket_connecting)

	# If you want to track Presence
	presence = PhoenixPresence.new()

	# Subscribe to Presence events (sync_diff and sync_state are also implemented)
	presence.on_join.connect(_on_Presence_join)
	presence.on_leave.connect(_on_Presence_leave)

	# Create a Channel
	channel = socket.channel("godot", {"host": "godot"}, presence)

	# Subscribe to Channel events
	channel.on_event.connect(_on_Channel_event)
	channel.on_join_result.connect(_on_Channel_join_result)
	channel.on_error.connect(_on_Channel_error)
	channel.on_close.connect(_on_Channel_close)

	call_deferred("add_child", socket, true)

	# Connect!
	socket.connect_socket()


func send_game_state(state: Dictionary) -> void:
	#print(state)
	#print("sending game state")
	var res = channel.push("game_state", state)
	#print("after push")
	#print(res)

#
# Socket events
#

func _on_Socket_open(payload):
	channel.join()
	print("_on_Socket_open: ", " ", payload)

func _on_Socket_close(payload):
	print("_on_Socket_close: ", " ", payload)

func _on_Socket_error(payload):
	print("_on_Socket_error: ", " ", payload)

func _on_Socket_connecting(is_connecting):
	print("_on_Socket_connecting: ", " ", is_connecting)

#
# Channel events
#

func _on_Channel_event(event: String, payload, status):
	#print("_on_Channel_event:  ", event, ", ", status)
	if payload.has("player_id"):
		var player_id: String = payload.player_id
		#if !%Players.has_player(player_id):
			#%Players.player_join(player_id, player_id)
		#var player: Player = %Players.get_player(player_id)
		#assert(player != null)
		if event == "pop":
			tap.emit(Vector2i(payload.x, payload.y), player_id)
			#%Bubbles.pop(Vector2i(payload.x, payload.y), player)
			#channel.push("game_state", {})
		if event == "scroll":
			%Players.show_player(payload.player_id, Vector2(payload.scroll_x, payload.scroll_y))
			#print(payload)
			# TODO: Do something with them

func _on_Channel_join_result(status, result):
	print("_on_Channel_join_result:  ", status, result)

func _on_Channel_error(error):
	print("_on_Channel_error: " + str(error))

func _on_Channel_close(closed):
	print("_on_Channel_close: " + str(closed))

#
# Presence events
#

func _on_Presence_join(joins):
	for join in joins:
		player_join.emit(join.key)
		#%Players.player_join(join.key, join.key)
	print("_on_Presence_join: " + str(joins))

func _on_Presence_leave(leaves):
	for leave in leaves:
		player_leave.emit(leave.key)
		#%Players.player_leave(leave.key)
	print("_on_Presence_leave: " + str(leaves))
