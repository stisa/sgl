import webgl

type BufferKind* {.pure.} = enum
  Vertex = 0x8892 # Passed to bindBuffer or bufferData to specify the type of buffer being used. 
  Index = 0x8893 # Passed to bindBuffer or bufferData to specify the type of buffer being used. 

type DrawMode* {.pure.} = enum
  Stream = 0x88E0 # Passed to bufferData as a hint about whether the contents of the buffer are likely to not be used often. 
  Static = 0x88E4 # Passed to bufferData as a hint about whether the contents of the buffer are likely to be used often and not change often. 
  Dynamic = 0x88E8 # Passed to bufferData as a hint about whether the contents of the buffer are likely to be used often and change often. 
  
type Buffer* = object
  gl: WebglRenderingContext # Is this a ref? mmh I don't like it
  glbuffer* : WebGLBuffer
  kind*: BufferKind
  drawmode*: DrawMode

proc buffer*(gl:WebglRenderingContext,
            kind:BufferKind,
            drawmode:DrawMode=DrawMode.Static) :Buffer=
  Buffer( gl: gl, glbuffer : gl.createBuffer(),
          kind:kind,
          drawmode: drawmode )

proc toJSA(v:openarray[float32]) :Float32Array {.importcpp: "new Float32Array(#)".} # might be a lie
proc toJSA(v:openarray[float]) :Float32Array {.importcpp: "new Float32Array(#)".} # might be a lie
proc toJSA(v:openarray[uint16]) :Uint16Array {.importcpp: "new Uint16Array(#)".} # might be a lie
proc toJSA(v:openarray[int32]) :Int32Array {.importcpp: "new Uint16Array(#)".} # might be a lie
proc toJSA(v:openarray[int]) :Int32Array {.importcpp: "new Int32Array(#)".} # might be a lie

proc upload*(b:Buffer,data:openarray[uint|int|float|float32|uint16|int32]) =
  # Bind appropriate array buffer
  b.gl.bindBuffer(b.kind.uint, b.glbuffer)
  # Pass the vertex data to the buffer
  b.gl.bufferData(b.kind.uint, data.toJSA, b.drawmode.uint)
  # Unbind the buffer
  b.gl.bindBuffer(b.kind.uint, nil)

proc bindBuffers*(bs:varargs[Buffer]) =
  for b in bs: 
    b.gl.bindbuffer(b.kind.uint,b.glbuffer)