import ../src/sgl

# Vertex shader source code
var vertCode = """
attribute vec2 coordinates;
void main(void) {
 gl_Position = vec4(coordinates, 0.0, 1.0);
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
  0.0,0.5,
  -0.5,-0.5,
  0.5,-0.5
]

var indices = [0'u16,1,2]

var stt = initstate("sgl-canvas",vertcode,fragCode)
stt.upload(vertices,indices)
stt.point("coordinates")
stt["u_color"] = [0.0,0,0,1]

proc draw(dt:float=0) = 
  # Draw the triangle
  stt.drawElementsAs(pmTriangles) 

  # make changes ...

  # Loop
  requestAnimationFrame(draw)

# Start looping
draw()