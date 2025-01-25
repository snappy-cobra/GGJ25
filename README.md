# Bubble Wrap

(_Name TBD_)

## How to install and run

1. The game consists of:
  - The networking server, written in Elixir (+ Phoenix).
  - The main game shown on the main screen, written in Godot.
  - A HTML (+ a sprinkle of JS) web client, served by the Elixir/Phoenix app

### Installation

- Install Godot by following https://godotengine.org/
- Install Elixir by following https://elixir-lang.org/install.html

### First Run

Open the folder `bubbleserver` and in here run `mix setup` to compile the Elixir app for the first time.
Then, run `mix phx.server` to run the Elixir server app.
It will run on `localhost:4000` by default.


Separately, open the folder `game`. This is a Godot project.
To make Godot know where the Elixir app is running: 
- copy the file `.env.example` to `.env` (this `.env` file is intentionally not tracked by git)
  - To connect to the locally-running Elixir server, fill in `ws://localhost:4000/socket`
  - To connect to the remotely-running Elixir server, fill in `wss://bubbleserver.fly.dev/socket` (or e.g. `wss://yourdomain.com/socket`) (Note the `wss://` with the extra s!)

### Any other run

- From the `bubbleserver` dir, run `mix phx.server`
- From the `game` dir, start and run the Godot project.

When running Godot while the Elixir app is running, it will try to connect to the Elixir app. Check its logs for details.

### How to (re)deploy

We're running an instance of the Elixir service on http://fly.io
Installation guide for the `fly` CLI program: https://fly.io/docs/flyctl/install/

(If you're not part of Snappy Cobra and would like to run a version of the program yourself on Fly,
run `fly launch` from the `bubbleserver` subdirectory.)

- To deploy, run `fly deploy`
- To view the live logs, run `fly logs`
