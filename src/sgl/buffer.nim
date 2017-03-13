import webgl,utils

type BufferKind* {.pure.} = enum
  Vertex = 0x8892 # Passed to bindBuffer or bufferData to specify the type of buffer being used. 
  Index = 0x8893 # Passed to bindBuffer or bufferData to specify the type of buffer being used. 

type DrawMode* {.pure.} = enum
  Stream = 0x88E0 # Passed to bufferData as a hint about whether the contents of the buffer are likely to not be used often. 
  Static = 0x88E4 # Passed to bufferData as a hint about whether the contents of the buffer are likely to be used often and not change often. 
  Dynamic = 0x88E8 # Passed to bufferData as a hint about whether the contents of the buffer are likely to be used often and change often. 
  
type Buffer* = object
  gl*: WebglRenderingContext # Is this a ref? mmh I don't like it
  glbuffer* : WebGLBuffer
  kind*: BufferKind
  datatype*: DataType
  drawmode*: DrawMode

proc buffer*(gl:WebglRenderingContext,
            kind:BufferKind,
            drawmode:DrawMode=DrawMode.Static) :Buffer=
  if kind==BufferKind.Index:
    Buffer( gl: gl, glbuffer : gl.createBuffer(),
            kind:kind,datatype:dtUnsignedShort,
            drawmode: drawmode )
  else:
    Buffer( gl: gl, glbuffer : gl.createBuffer(),
          kind:kind,datatype:dtFloat,
          drawmode: drawmode )
          
proc upload*(b:Buffer,data:Bufferables) =
  # Bind appropriate array buffer
  b.gl.bindBuffer(b.kind.uint, b.glbuffer)
  # Pass the vertex data to the buffer
  b.gl.bufferData(b.kind.uint, data.toJSA, b.drawmode.uint)
  # Unbind the buffer
  b.gl.bindBuffer(b.kind.uint, nil)

proc bindBuffers*(bs:varargs[Buffer]) =
  for b in bs: 
    b.gl.bindbuffer(b.kind.uint,b.glbuffer)