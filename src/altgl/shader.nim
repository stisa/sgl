import webgl

import utils

type ShaderOptions* = concept s
  s.vertexshader is string
  s.fragmentshader is string
  
type Shader* = object
  glprogram* : WebglProgram

proc shader*(
    glprogram:WebGLProgram):Shader =
  Shader( 
    glprogram : glprogram
  )
