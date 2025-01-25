// token for authentication. Read below how it should be used.
let socket = new window.Phoenix.Socket("http://localhost:4000/socket", {params: {token: "oke"}})

// connect to the websocket:
socket.connect()
let channel = socket.channel("godot", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


var SIZE = 16; 


var bubblePopFunction = function() {
    
    // Sound
    var sound = new Howl({
        src: ['pop.mp3']
    });
      
    sound.play();

    // get the XY of this div
    var index = this.getAttribute("id");
    var index_x = index % SIZE;
    var index_y = Math.floor(index / SIZE);

    console.log("POP " + index + " ("+index_x+","+index_y+")")
    channel.push("pop", {x: index_x, y: index_y});

    // Vibrate
    navigator.vibrate(200);
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

for (var i = 0; i < 100; i++) {
    const cell = document.createElement('div');
    cell.className = "cell";
    cell.setAttribute('id', i);

    board.appendChild(cell);

    if (i % 20 == 1) {
        cell.innerHTML = svgStarString;
    } else {
        cell.innerHTML = svgString;
    }

    cell.addEventListener('click', bubblePopFunction, false);
}
