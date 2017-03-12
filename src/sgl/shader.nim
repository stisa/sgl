import webgl

import utils

const DefaultVS =  """
attribute vec4 aPosition;
uniform mat4 uMatrix;
void main() {
  gl_Position = uMatrix*aPosition;
}
"""

const DefaultFS = """
#ifdef GL_ES
  precision highp float;
#endif

uniform vec4 uColor;
void main() {
  gl_FragColor = uColor;
}
"""

type Shader* = object
  glprogram* : WebglProgram

proc shader*(gl:WebglRenderingContext,vssrc:string=DefaultVS,fssrc:string=DefaultFS):Shader = 
  let vs = gl.createShader(seVertexShader)
  gl.shadersource(vs,vssrc)
  gl.compileShader(vs)
  if not gl.getStatus(vs): echo "error vertex shader"

  let fs = gl.createShader(seFragmentShader)
  gl.shadersource(fs,fssrc)
  gl.compileShader(fs)
  if not gl.getStatus(fs): echo "error fragment shader"
  
  let prog = gl.createProgram()
  gl.attachShader(prog,vs)
  gl.attachShader(prog,fs)
  gl.linkProgram(prog)
  if not gl.getStatus(prog): echo "error linking program"
  
  result.glprogram = prog
  
  gl.deleteShader(vs)
  gl.deleteShader(fs)