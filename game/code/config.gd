extends Node

var dotenv = {}

func _ready() -> void:
	var envfile := FileAccess.open("res://.env", FileAccess.READ)
	if envfile != null:
		while ! envfile.eof_reached():
			var entry := envfile.get_line().strip_edges().split("=", true, 1)
			if entry.size() == 2 && entry[0].length() > 0 && entry[0][0] != "#":
				dotenv[entry[0]] = entry[1]

func read_env(key: String) -> String:
	if OS.has_environment(key):
		return OS.get_environment(key)
	else:
		return dotenv.get(key)


func server_url() -> String:
	return read_env("SNAPPY_SERVER")

func server_password() -> String:
	return read_env("SNAPPY_PASSWORD")
