import webgl

import utils

type BufferKind* {.pure.}= enum
  Vertex = BufferEnum.beArrayBuffer
  Index = BufferEnum.beElementArrayBuffer

type Usage* {.pure.} = enum
  Stream = BufferEnum.beSTREAM_DRAW,
  Immutable = BufferEnum.beSTATIC_DRAW,
  Mutable = BufferEnum.beDynamic_DRAW

type BufferOptions* = concept b
  b.kind is BufferKind
  b.usage is Usage
  b.data is ?ref array
  b.len is ?Natural

type Buffer* = object
  glbuffer* : WebglBuffer
  usage: Usage
  kind: BufferKind

proc kind(b:Buffer):Bufferkind=b.kind
proc usage(b:Buffer):Usage=b.usage

proc buffer*(
    o:BufferOptions,
    glbuffer:WebGLBuffer):Buffer =
  Buffer( 
    kind : o.kind,
    usage : o.usage, # should default to (Usage.Immutable)
    glbuffer : glbuffer 
  )
