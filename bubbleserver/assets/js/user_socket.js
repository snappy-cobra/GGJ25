"use strict";
// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"
import {Howl} from "../vendor/howler.js"

// And connect to the path in "lib/bubbleserver_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/bubbleserver_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/bubbleserver_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/bubbleserver_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// // Now that you are connected, you can join channels with a topic.
// // Let's assume you have a channel with a topic named `room` and the
// // subtopic is its id - in this case 42:
// let channel = socket.channel("godot", {})
// channel.join()
//   .receive("ok", resp => { console.log("Joined successfully", resp) })
//   .receive("error", resp => { console.log("Unable to join", resp) })

// channel.on("game_state", function(state) {
//   console.log("Received game state:", state)
// })

// window.pop = function (y, x) {
//   console.log("POP")
//   if(typeof window.navigator.vibrate === 'function') {
//     window.navigator.vibrate(50);
//   }
//   channel.push("pop", {x: x, y: y});
// }


// token for authentication. Read below how it should be used.
// let socket = new window.Phoenix.Socket("http://localhost:4000/socket", {params: {token: "player:"+Math.random()*99999}})


var WIDTH = 50;
var HEIGHT = 25;

var state = null;
var my_player_id = null;
var my_team = null;

// connect to the websocket:
socket.connect()
let channel = socket.channel("godot", {})
channel.join()
  .receive("ok", player_id => { 
    console.log("Joined successfully, player_id set:", player_id) 
    my_player_id = player_id;
    // my_team = null;//player_id % 2;
    // displayTeam();
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("game_state", resp => {
    console.log("local state", resp);
    if (resp.state != "running") { return; }
    // WIDTH = resp.bubbles.size[0]
    // HEIGHT = resp.bubbles.size[1]
    let bubbles = resp.bubbles.bubbles;
    if (resp.players[my_player_id].team !== my_team) {
        my_team = resp.players[my_player_id].team;
        displayTeam();
    }
    if (state === null || WIDTH !== resp.bubbles.size[0] || HEIGHT  !== resp.bubbles.size[1] || resp.reset) {
        WIDTH = resp.bubbles.size[0];
        HEIGHT = resp.bubbles.size[1];
        buildBoard(bubbles);
    } else {
        for (let i in bubbles) {
            let bubble = bubbles[i];
            let oldBubble = state[i];
            if (!(bubble[0] === oldBubble[0] && bubble[1] === oldBubble[1])) {
                let cell = document.getElementById("cell-"+i);
                redrawBubble(cell, bubble)
            }
        }
    }
    state = bubbles
})

var fibonacciHash = function(int) {
  const a = 40503
  const max32bit = 65536
   return (int * a) % max32bit
}

var redrawBubble = function(cell, bubbleState) {
  // if(bubbleState[0] == 0) {
  //   // Don't show a number for counts of 1 and 0
  //   // Instead, use a non-breaking space
  //   // to not mess with the wonky CSS
  //   // cell.innerText = "\u00A0"
  // } else {
    if(bubbleState[0] > 0) {
      // If greater than zero, that is the remaining count
      // and index 1 is something else (score popping this gives you?)
      cell.innerText = bubbleState[0]
      cell.dataset.tapsLeft = bubbleState[0]
    } else {
      // Index 1 is the team
      cell.dataset.team = bubbleState[1]
    }
  // }
  // if (!cell) { continue; }
  if (bubbleState[0]) {
    cell.classList.add("unpopped")
    cell.classList.remove("popped")
    if(cell.dataset.popped) {
      delete cell.dataset.popped
    }
  } else {
    cell.classList.remove("unpopped")
    cell.classList.add("popped")
    cell.dataset.popped = "popped"
    cell.innerText = "\u00A0"
  }
}

var bubblePopFunction = function() {
    if(this.dataset.popped) {
      return
    }

    if(+this.dataset.tapsLeft > 1) {
      console.log(this.dataset.tapsLeft)
      playTabSound(); // Play tap sound
    } else {
      playPopSound(); // Play pop sound
    }

    // get the XY of this div
    const index_y = +this.dataset.row
    const index_x = +this.dataset.col
    // var index = this.getAttribute("index");
    // var index_x = index % WIDTH;
    // var index_y = Math.floor(index / WIDTH);

    //console.log("POP " + index + " ("+index_x+","+index_y+")")
    console.log("POP", index_x, index_y)
    channel.push("pop", {x: index_x, y: index_y});

    // Vibrate
    if (typeof navigator.vibrate === 'function') {
        navigator.vibrate(50);
    }
    if (typeof navigator.mozVibrate === 'function') {
        navigator.mozVibrate(50);
    }
};

var playTabSound = function() {
    sounds = ['/sounds/tap1loud.mp3', '/sounds/tap2loud.mp3', '/sounds/tap3loud.mp3', '/sounds/tap4loud.mp3', '/sounds/tap5loud.mp3']
    playRandomSound(sounds)
}

var playPopSound = function() {
    sounds = ['/sounds/pop.mp3', '/sounds/pop1.mp3', '/sounds/pop2.mp3', '/sounds/pop3.mp3']
    playRandomSound(sounds)
}

var playRandomSound = function(sounds) {
    const random = Math.floor(Math.random() * sounds.length);

    var sound = new Howl({
        src: sounds[random]
    });
    sound.rate = 1 + (Math.random() - 0.5)
    sound.volume(Math.random() * 0.4 + 0.6)
      
    sound.play();
}


board = document.getElementById("board");

function buildCell(row, col, state) {
  const index = row * WIDTH + col;
  const cell = document.createElement('div')
  cell.className = 'cell'
  cell.id = "cell-" + index
  cell.setAttribute('index', index);
  cell.dataset.row = row;
  cell.dataset.col = col;
  cell.dataset.bubblePic = fibonacciHash(index) >> 15;
  // cell.innerHTML = svgString
  redrawBubble(cell, state)
  cell.addEventListener('click', bubblePopFunction, false)
  return cell
}

function buildBoard(state) {
  document.getElementById("board")
  board.innerHTML = ""

  for(var row=0; row < HEIGHT; ++row) {

    const rowElem = document.createElement('div')
    rowElem.className = "row"

    for(var col=0; col < WIDTH; ++col) {
      let i = col + row * WIDTH;
      const cell = buildCell(row, col, state[i])
      rowElem.appendChild(cell)
    }

    board.appendChild(rowElem)
  }
  // let i = 0
  // for (var y=0; y < HEIGHT; y++) {
  //     const row = document.createElement('div');
  //     row.className = "row";
  //     board.appendChild(row);

  //     for (var x = 0; x < WIDTH; x++) {
  //         const cell = document.createElement('div');
  //         cell.className = "cell";
  //         cell.id = "cell-"+i;
  //         cell.setAttribute('index', y * WIDTH + x);
  //         state[i] = [1, 1]

  //         row.appendChild(cell);

  //         cell.innerHTML = svgString;

  //         cell.addEventListener('click', bubblePopFunction, false);
  //         i++;
  //     }
  // }
}

function displayTeam() {
    let teambar = document.getElementById("teambar")
    teambar.dataset.team = my_team;
    console.log("setting team", my_team)
}

// buildBoard(state)




export default socket
