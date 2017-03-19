import webgl, dom,math,jsconsole
import ../src/sgl/[state,utils]

# Vertex shader source code
var vertCode = """
uniform mat3 rotation;
uniform mat3 projection;
attribute vec3 coordinates;
void main(void) {
 gl_Position = vec4(projection*rotation*coordinates, 1.0);
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
  0.0,0,0.0,
  100,0,0.0,
  100,100,0.0, 
  100,100,0.0,
  0, 100,0.0,
  0, 0, 0.0
];

var lastrotation = [
  1.0,0,0,
  0,1,0,
  0,0,1,
];

var indices = [0'u16,1,2,3,4,5];

var sgl = initstate("sgl-canvas",vertcode,fragCode)

sgl.upload(vertices,indices)

sgl.point("coordinates") # Tell webgl that the buffers we just uploaded are "coordinates"
sgl["projection"] = projection3(sgl.gl.drawingbufferwidth.float,sgl.gl.drawingbufferheight.float)
sgl["rotation"] = lastrotation # set the uniform "rotation"
sgl["u_color"] = [0.0,0,0,1] # set the uniform "u_color"

var theta = 0.0

var counter = 0
var starttime = 0.0
var fpstime = 0.0

proc draw(dt:float) =
  # Loop
  
  # FPS counter
  fpstime += dt-starttime
  if fpstime>1000:
    console.log counter
    counter = 0
    fpstime = 0
  
  # Limit to 60fps
  if dt-starttime>1000/60:  
    starttime = dt
    inc counter

    # Draw the triangle
    sgl.drawElementsAs(pmTriangles)
    
    # Update rotation uniform
    if rotation3(theta) != lastrotation:
      sgl["rotation"] = rotation3(theta)
      lastrotation = rotation3(theta)
  
  theta+=1

  # Keep looping
  requestAnimationFrame(draw)

# Example binding keyboard input
proc keyev(e:dom.Event) =
  if (char(e.keycode)) == 'a':
    theta+=45 # rotate counterclockwise
  elif (char(e.keycode)) == 'd':
    theta-=45 # rotate clockwise
document.addEventlistener("keypress",keyev,true)
  

# Start looping
draw(0.0)
