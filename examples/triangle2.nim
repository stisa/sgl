import webgl, dom
import ../src/sgl/[state,utils]

var canvas = dom.document.getElementById("sgl-canvas").Canvas;
var gl = canvas.getContextWebgl()
canvas.resizeToDisplaySize
var vertices = [
  -0.5'f32,0.5,0.0,
  -0.5,-0.5,0.0,
  0.5,-0.5,0.0, 
];

var indices = [0'u16,1,2];

# Vertex shader source code
var vertCode = """attribute vec3 coordinates;
void main(void) {
 gl_Position = vec4(coordinates, 1.0);
}"""

#fragment shader source code
var fragCode ="""
void main(void){
  gl_FragColor = vec4(0.0, 0.0, 0.0, 0.1);
}"""


var stt = gl.state(vertcode,fragCode)

stt.upload(vertices,indices)

stt.point("coordinates")

stt.drawAsTriangle