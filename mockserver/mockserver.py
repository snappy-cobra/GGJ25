#!/usr/bin/env python3

from websockets.sync.server import serve
import json
from time import sleep


def mockserve(websocket):
	for message in websocket:
		if json.loads(message) == {"type": "hostconnect", "password": "hunter2"}:
			websocket.send(json.dumps({"type": "connectsuccess"}))
			sleep(1)
			websocket.send(json.dumps({"type": "playerjoin", "id": "mockey", "name": "MockeyMouse"}))
			sleep(1)
			websocket.send(json.dumps({"type": "playerinput", "id": "mockey", "inputtype": "move", "movement": [1, 0]}))
			sleep(1)
			websocket.send(json.dumps({"type": "playerinput", "id": "mockey", "inputtype": "move", "movement": [0, 1]}))
			sleep(1)
			websocket.send(json.dumps({"type": "playerinput", "id": "mockey", "inputtype": "move", "movement": [0, 0]}))
			sleep(1)
			websocket.send(json.dumps({"type": "playerleave", "id": "mockey"}))
		else:
			websocket.send(json.dumps({"type": "error", "msg": "unknown message"}))


def main():
	with serve(mockserve, "localhost", 2025) as server:
		server.serve_forever()


if __name__ == "__main__":
	main()
