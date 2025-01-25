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

// connect to the websocket:
socket.connect()
let channel = socket.channel("godot", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
  .receive("godot", resp => { console.log("godot", resp) })
  .receive("game_state", resp => { console.log("gamestate", resp) })

channel.on("game_state", resp => {console.log("state", resp)}) 

var WIDTH = 50; 
var HEIGHT = 25;


var bubblePopFunction = function() {
    
    // Sound
    var sound = new Howl({
        src: ['/sounds/pop.mp3']
    });
    sound.seek(0.21);
      
    sound.play();

    // get the XY of this div
    var index = this.getAttribute("id");
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


for (var y = 0; y < HEIGHT; y++) {
    const row = document.createElement('div');
    row.className = "row";
    board.appendChild(row);

    for (var x = 0; x < WIDTH; x++) {
        const cell = document.createElement('div');
        cell.className = "cell";
        cell.setAttribute('id', y * WIDTH + x);

        row.appendChild(cell);

        if (x % 20 == 7) {
            cell.innerHTML = svgStarString;
        } else {
            cell.innerHTML = svgString;
        }

        cell.addEventListener('click', bubblePopFunction, false);
    }
}




export default socket
