SGL
===

[docs](http://stisa.space/sgl)

```nim
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

  # Loop
  requestAnimationFrame(draw)

# Start looping
draw()
```

TODO
====
- rename project and find a better name for state (?)
- use a proper math lib (snail/graphics ? or just basic2d, basic3d ? or move the current one out of utils). Do i really need to? Math is up to the user anyway.