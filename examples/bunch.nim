import ../src/sgl
import ../src/sgl/utils

import random

# Vertex shader source code
var vertCode = """
attribute vec2 coordinates;
uniform mat2 scale;
void main(void) {
 gl_Position = vec4(scale*coordinates, 0.0, 1.0);
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

var vertices = [
  0.0,50,
  -50,-50,
  50,-50
]

var indices = [0'u16,1,2]

var stt = initstate("sgl-canvas",vertcode,fragCode)
stt.upload(vertices,indices)
stt.point("coordinates")
stt["u_color"] = [0.0,0,0,1]
stt["scale"] = projection2(stt.width, stt.height)

setupfpscounter()

proc draw(dt:float=0) = 
  vertices = [random(200.0),random(200.0),random(200.0),random(200.0),random(200.0),random(200.0)]
  stt.upload(vertices)
  # Draw the triangle
  stt.drawElementsAs(pmTriangles) 

  # make changes ...

  # Loop
  requestAnimationFrame(draw)

# Start looping
draw()