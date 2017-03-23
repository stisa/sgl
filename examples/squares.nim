import webgl, dom,math,jsconsole
import ../src/sgl/[state,utils]

let 
  # Vertex shader source code
  vertCode = """
  uniform mat3 translation;
  uniform mat3 projection;
  uniform mat3 rotation;
  attribute vec2 coordinates;
  void main(void) {
    gl_Position = vec4( vec3( projection * translation * rotation * vec3(coordinates,1.0) ).xy, 0.0 , 1.0);
  }
  """
  #fragment shader source code
  fragCode ="""
  precision mediump float;
  uniform vec4 u_color;
  void main(void) {
    gl_FragColor = u_color;
  }
  """

  vertices = [
    0.0,0,
    100,0,
    100,100
  ];

var 
  lasttranslation = translation3(0,0)
  lastrotation = rotation3(0.0)
  indices = [0'u16,1,2]

  sgl = initstate("sgl-canvas",vertcode,fragCode)

sgl["projection"] = projection3(sgl.gl.drawingbufferwidth.float,sgl.gl.drawingbufferheight.float)
sgl["translation"] = lasttranslation # set the uniform "translation"
sgl["rotation"] = rotation3(0) # set the uniform "translation"
sgl["u_color"] = [0.0,0,0,1] # set the uniform "u_color"

sgl.upload(vertices,indices)
sgl.point("coordinates") # Tell webgl that the buffers we just uploaded are "coordinates"

var
  dx,dy,theta = 0.0

  last_time = -1.0
  dt = 0.0

setupFPSCounter("output")

proc draw() =
  # Update translation uniforms
  if translation3(dx,dy) != lasttranslation:
    sgl["translation"] = translation3(dx,dy)
    lasttranslation = translation3(dx,dy)
  if rotation3(theta) != lastrotation:
    sgl["rotation"] = rotation3(theta)
    lastrotation = rotation3(theta)
  # Draw the triangle
  sgl.drawElementsAs(pmTriangles)

proc update(then:float) =
  # Main Loop
  requestAnimationFrame(update)

  dt = then - last_time

  # Limit to 30fps
  if dt>1000/30:  
    # FPS counter
    updateFpsCounter(dt)
    draw()
    last_time = then

# Example binding keyboard input
proc keyev(e:dom.Event) =
  if (char(e.keycode)) == 'a':
    dx-=30 
  elif (char(e.keycode)) == 'd':
    dx+=30 
  elif (char(e.keycode)) == 'w':
    dy+=30
  elif (char(e.keycode)) == 's':
    dy-=30
  elif (char(e.keycode)) == 'q':
    theta-=5
  elif (char(e.keycode)) == 'e':
    theta+=5
document.addEventlistener("keypress",keyev,true)

# Start looping
update(0.0)
