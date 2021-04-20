var canvas;
var ctx;

// Setup event listeners
window.addEventListener("load", () => {

    document.addEventListener("mousedown", beginDraw);
    document.addEventListener("mouseup", endDraw);
    document.addEventListener("mousemove", mouseMoved);

    canvas = document.getElementById("canvas");
    ctx = canvas.getContext("2d");

});

/*

The following is all related to drawing and keeping
track of the points.

*/

// Keeps track of data for drawing
var mousePos = { x: 0, y: 0 };
var drawing = false;
var hasDrawn = false;

// Keeps track of what points were used
var points = [];

// Updated the mouse position, clamping it for the edges
// of the canvas
function updateMousePos(event) {
    mousePos.x = event.clientX - canvas.offsetLeft;
    mousePos.y = event.clientY - canvas.offsetTop;

    if (mousePos.x < 0) mousePos.x = 0;
    if (mousePos.y < 0) mousePos.y = 0;

    if (mousePos.x >= canvas.width) mousePos.x = canvas.width - 1;
    if (mousePos.y >= canvas.height) mousePos.y = canvas.height - 1;
}

// Checks if the mouse is in the boundes
// of the canvas
function mouseInBounds(event) {
    var mX = event.clientX - canvas.offsetLeft;
    var mY = event.clientY - canvas.offsetTop;

    return !(mX < 0 || mY < 0 || mX >= canvas.width || mY >= canvas.height);
}

// Start drawing, only if within the canvas and there
// isnt already a drawing on the canvas
function beginDraw(event) {
    if (!hasDrawn && mouseInBounds(event)) {
        drawing = true;
        updateMousePos(event);
    }
}

// Stop drawing, and connect the endpoints of the drawing
function endDraw(event) {
    if (drawing) {
        hasDrawn = true;

        // Draw last connecting line
        var firstPoint = points[0];
        var lastPoint = points[points.length - 1];
        if (firstPoint.x != lastPoint.x || firstPoint.y != lastPoint.y) {

            ctx.beginPath();

            ctx.lineWidth = 5;
            ctx.lineCap = "round";
            ctx.strokeStyle = "black";

            ctx.moveTo(lastPoint.x, lastPoint.y);
            ctx.lineTo(firstPoint.x, firstPoint.y);

            ctx.stroke();

            points.push({ x: firstPoint.x, y: firstPoint.y });

            // Now we must scale the points to be in [-1,1]
            for (var i = 0; i < points.length; i++) {
                var curPoint = points[i];
                curPoint.x = curPoint.x / (canvas.width / 2) - 1;
                curPoint.y = (curPoint.y / (canvas.height / 2) - 1) * -1;
            }

        }
    }
    drawing = false;

}

// Draw a line from the previous position and the
// new position
function mouseMoved(event) {
    if (!drawing || hasDrawn) return;

    ctx.beginPath();

    ctx.lineWidth = 5;
    ctx.lineCap = "round";
    ctx.strokeStyle = "black";

    ctx.moveTo(mousePos.x, mousePos.y);
    points.push({ x: mousePos.x, y: mousePos.y }); // Keep track of the points in the drawing
    updateMousePos(event);
    ctx.lineTo(mousePos.x, mousePos.y);

    ctx.stroke();

}

// Reset the drawing
function resetDrawing() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    hasDrawn = false;
    points = [];
}

/*

Here's the important part of the code:

We have an array of (x,y) coordinates denoting the points the define
the drawing, we will output this to a text file to load as a matrix
into MATLAB

*/


// Downloads a .txt file describing a matrix for MATLAB
function downloadPoints() {

    var fileContents = "";

    for (var i = 0; i < points.length; i++) {
        fileContents += points[i].x + "," + points[i].y;
        if (i != points.length - 1) fileContents += "\n";
    }

    downloadFile("OutputPoints.txt", fileContents);

}

// Creates and downloads a file with name [fileName] and text contents of [contents]
function downloadFile(fileName, contents) {
    var element = document.createElement('a');
    element.setAttribute("href", "data:text/plain;charset=utf-8," + encodeURIComponent(contents));
    element.setAttribute("download", fileName);

    element.style.display = "none";
    document.body.appendChild(element);

    element.click();

    document.body.removeChild(element);
}