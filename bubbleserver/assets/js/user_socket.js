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

// connect to the websocket:
socket.connect()
let channel = socket.channel("godot", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("game_state", resp => {
    console.log("local state", resp);
    if (resp.state != "running") { return; }
    // WIDTH = resp.bubbles.size[0]
    // HEIGHT = resp.bubbles.size[1]
    let bubbles = resp.bubbles.bubbles;
    if (state === null || WIDTH !== resp.bubbles.size[0] || HEIGHT  !== resp.bubbles.size[1] || resp.reset) {
        WIDTH = resp.bubbles.size[0];
        HEIGHT = resp.bubbles.size[1];
        buildBoard(bubbles);
    } else {
        for (let i in bubbles) {
            let bubble = bubbles[i];
            let oldState = state[i];
            if (!(bubble[0] === oldState[0] && bubble[1] === oldState[1])) {
                let cell = document.getElementById("cell-"+i);
                // if (!cell) { continue; }
                if (bubble[0]) {
                    cell.innerHTML = svgString;
                } else {
                    cell.innerHTML = svgStarString;
                }
            }
        }
    }
    state = bubbles
})



var bubblePopFunction = function() {
    
    // Sound
    sounds = ['/sounds/pop.mp3', '/sounds/pop1.mp3', '/sounds/pop2.mp3', '/sounds/pop3.mp3']
    const random = Math.floor(Math.random() * sounds.length);

    var sound = new Howl({
        src: sounds[random]
    });
    sound.rate = 1 + (Math.random() - 0.5)
    sound.volume(Math.random() * 0.4 + 0.6)
      
    sound.play();

    // get the XY of this div
    var index = this.getAttribute("index");
    var index_x = index % WIDTH;
    var index_y = Math.floor(index / WIDTH);

    console.log("POP " + index + " ("+index_x+","+index_y+")")
    channel.push("pop", {x: index_x, y: index_y});

    // Vibrate
    if (typeof navigator.vibrate === 'function') {
        navigator.vibrate(200);
    }
    if (typeof navigator.mozVibrate === 'function') {
        navigator.mozVibrate(200);
    }
};


board = document.getElementById("board");

const svgString = `
<svg class="bubble" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
    <path fill="#F2F4F8" d="M62.3,-50.7C76.8,-31.5,81.8,-5.9,77,18.4C72.1,42.8,57.4,65.7,36.4,75.9C15.5,86,-11.7,83.4,-34.3,72.2C-56.9,61,-75,41.1,-81,17.6C-87.1,-5.9,-81.1,-32.9,-65.6,-52.3C-50.2,-71.6,-25.1,-83.2,-0.6,-82.8C23.9,-82.3,47.8,-69.8,62.3,-50.7Z" transform="translate(100 100)" />
</svg>
`;

const svgStarString = `
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
<polygon
    points="100,10 120,70 180,70 130,110 150,170 100,130 50,170 70,110 20,70 80,70"
    fill="gold"
    stroke="orange"
    stroke-width="3"
/>
</svg>
`;

function buildCell(row, col) {
  const index = row * WIDTH + col;
  const cell = document.createElement('div')
  cell.className = 'cell'
  cell.id = "cell-" + index
  cell.setAttribute('index', index);
  cell.innerHTML = svgString
  cell.addEventListener('click', bubblePopFunction, false)
  return cell
}

function buildBoard(state) {
  for(var row=0; row < HEIGHT; ++row) {

    const rowElem = document.createElement('div')
    rowElem.className = "row"

    for(var col=0; col < WIDTH; ++col) {
      state[row * WIDTH + col] = [1, 1]
      const cell = buildCell(row, col)
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

buildBoard(state)



export default socket
