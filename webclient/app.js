canvas = document.getElementById("canvas")

canvas.addEventListener('click', function() { 
    navigator.vibrate(200);
    console.log("Vibrate");
}, false);

