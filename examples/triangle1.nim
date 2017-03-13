import webgl, dom
import ../src/sgl/[shader,buffer,utils]

var canvas = dom.document.getElementById("sgl-canvas").Canvas;
var gl = canvas.getContextWebgl()
canvas.resizeToDisplaySize
var vertices = [
  -0.5'f32,0.5,0.0,
  -0.5,-0.5,0.0,
  0.5,-0.5,0.0, 
];

var indices = [0'u16,1,2];

# Create an empty buffer object to store vertex buffer
var vb = gl.buffer(BufferKind.Vertex)

vb.upload(vertices)

# Create an empty buffer object to store Index buffer
var ib = gl.buffer(BufferKind.Index)

ib.upload(indices)

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

let shd = gl.shader(vertCode,fragCode)

# Bind vertex buffer object
bindBuffers(vb,ib)

# Point attribute to the currently bound VBO
var coord = shd.attributes["coordinates"] #shd.attributes["coordinates"]
gl.point(coord)

# Clear the canvas
gl.clearColor(0.5, 0.5, 0.5, 0.9);

# Enable the depth test
gl.enable(0x0B71);

# Clear the color buffer bit
gl.clear(bbColor);

# Set the view port
gl.viewport(0,0,canvas.width,canvas.height);

# Draw the triangle
gl.drawElements(pmTriangles, indices.len, dtUnsignedShort,0) #0x1403 ??