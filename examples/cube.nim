import webgl, dom,math,jsconsole
import ../src/sgl/[state,utils]

let 
  # Vertex shader source code
  fragCode = """      
    precision mediump float;
    uniform vec4 color;
    void main(void) {
      gl_FragColor = color;
    }
  """
  vertcode = """
    attribute vec3 coordinates;
    uniform mat4 rot;
    void main(void) {
      gl_Position = rot*vec4(coordinates, 1.0);
    }
  """

let positions = [
  0.5,  0.5,  0.5,     # v0
  -0.5,  0.5,  0.5,    # v1
  -0.5, -0.5,  0.5,    # v2
  0.5, -0.5,  0.5,     # v3
  0.5, -0.5, -0.5,     # v4
  0.5,  0.5, -0.5,     # v5
  -0.5,  0.5, -0.5,    # v6
  -0.5, -0.5, -0.5,    # v7
]

let indices = [
  0'u16, 1, 2,   0, 2, 3,# front
  0, 3, 4,   0, 4, 5,    # right
  0, 5, 6,   0, 6, 1,    # up
  1, 6, 7,   1, 7, 2,    # left
  7, 4, 3,   7, 3, 2,    # down
  4, 7, 6,   4, 6, 5     # back
]

var sgl = initstate("sgl-canvas",vertcode,fragCode)

sgl.upload(positions,indices)
sgl.point("coordinates") # Tell webgl that the buffers we just uploaded are "coordinates"
sgl["rot"] = rotation4Y(0)

var theta = 0.0

proc draw() =
  # Update translation uniforms
  sgl["color"] = [1.0,0,0,1] # red
  sgl.drawElementsAs(pmTriangles) # draw the box
  sgl["color"] = [0.0,0,0,1] # black
  sgl.drawElementsAs(pmLineLoop) # draw the outline

proc update(then:float) =
  # Main Loop
  requestAnimationFrame(update)
  sgl["rot"] = rotation4Y(theta)
  theta += 0.5
  draw()

# Example binding keyboard input
proc keyev(e:dom.Event) =
  if (char(e.keycode)) == 'q':
    theta-=5
  elif (char(e.keycode)) == 'e':
    theta+=5
document.addEventlistener("keypress",keyev,true)

# Start looping
update(0.0)
