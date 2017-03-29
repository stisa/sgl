import webgl, dom,math
import ../src/sgl/[state,utils]

# Vertex shader source code
var vertCode = """
uniform mat3 rotation;
attribute vec3 coordinates;
void main(void) {
 gl_Position = vec4(rotation*coordinates, 1.0);
}
"""
#fragment shader source code
var fragCode ="""
precision mediump float;
uniform vec4 u_color;
void main(void) {
  gl_FragColor = u_color;
}
"""

let vertices = [
  0.0,0.5,0.0,
  -0.5,-0.5,0.0,
  0.5,-0.5,0.0, 
];

var rotation = [
  1.0,0,0,
  0,1,0,
  0,0,1,
];

var indices = [0'u16,1,2];

var stt = initstate("sgl-canvas",vertcode,fragCode)
stt.upload(vertices,indices)
stt.point("coordinates")
stt["rotation"] = rotation
stt["u_color"] = [0.0,0,0,1]

var theta = 0.0
proc draw(dt:float) = 
  # Loop
  requestAnimationFrame(draw)
  
  stt.drawElementsAs(pmLineLoop)

  # Update rotation uniform
  theta+=1.0
  rotation[0] = cos(degtorad(theta))
  rotation[1] = -sin(degtorad(theta))
  rotation[3] = sin(degtorad(theta))
  rotation[4] = cos(degtorad(theta))
  stt["rotation"] = rotation
  

# Start looping
draw(0.0)
