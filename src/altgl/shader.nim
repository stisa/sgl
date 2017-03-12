import webgl

import utils

type BufferKind* {.pure.}= enum
  Vertex = BufferEnum.beArrayBuffer
  Index = BufferEnum.beElementArrayBuffer

type Usage* {.pure.} = enum
  Stream = BufferEnum.beSTREAM_DRAW,
  Immutable = BufferEnum.beSTATIC_DRAW,
  Mutable = BufferEnum.beDynamic_DRAW

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
