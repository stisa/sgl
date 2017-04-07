{.warning[ProveInit]:off.}
import webgl, dom
import shader,buffer,utils

type State* = object
  gl*: WebglRenderingContext
  vb: Buffer # VertexBuffer
  ib: Buffer # IndexBuffer
  cb: Buffer # ColorBuffer
  shader*: Shader
  il : Natural # Indices len
  vl : Natural # Vertices len
  cl: Natural # Colors len


proc state*(gl:WebglRenderingContext,vs,fs:string):State =
  let vb = gl.buffer(BufferKind.Vertex)
  let ib = gl.buffer(BufferKind.Index)
  let cb = gl.buffer(BufferKind.Vertex)
  let shd = gl.shader(vs,fs)
  
  gl.clearColor(0.0, 0.0, 0.0, 0.0);
  gl.enable(0x0B71);
  gl.clear( ord(bbColor) or ord(bbDepth) )
  gl.canvas.resizeToDisplaySize(window.devicePixelRatio)
  gl.viewport(0,0,gl.drawingbufferwidth,gl.drawingbufferheight);
  
  bindBuffers(vb,ib)
  
  State(gl:gl,vb:vb,ib:ib,cb:cb,shader:shd,il:0,vl:0)

proc initState*(canvasId:string="sgl-canvas",vs=DefaultVS,fs:string=DefaultFS):State =
  ## Initialize the rendering context on canvas, with the shader source passed in.
  var canvas = dom.document.getElementById("sgl-canvas").Canvas;
  var gl = canvas.getContextWebgl()
  canvas.resizeToDisplaySize(window.devicePixelRatio)
  result = gl.state(vs,fs)

proc width*(s:State):float {.inline.} = s.gl.canvas.clientwidth.float
proc height*(s:State):float {.inline.}= s.gl.canvas.clientheight.float

proc upload*(s: var State,vertices:VertexBufferables,indices:IndexBufferables) =
  ## Upload and bind the vertex and index buffers
  s.vb.upload(vertices)
  s.ib.upload(indices)
  bindBuffers(s.vb,s.ib)
  s.il = indices.len
  s.vl = vertices.len

proc upload*(s: var State,vertices:VertexBufferables) =
  ## Upload the vertex buffer
  s.vb.upload(vertices)
  s.vl = vertices.len

proc upload*(s: var State,indices:IndexBufferables) =
  ## Upload the index buffer
  s.ib.upload(indices)
  s.il = indices.len

proc `color=`*(s: var State,colors:VertexBufferables) =
  ## Upload the color buffer
  # TODO: upload(colorbuffers)
  s.cb.upload(colors)
  s.cl = colors.len

proc point*(s:State,name:string) =
  ## Point attribute `name` to the currently bound VBO
  var coord = s.shader.attributes[name] #shd.attributes["coordinates"]
  s.gl.point(coord)

proc drawAsTriangle*(s:State) {.deprecated.}=
  #s.gl.viewport(0,0,s.gl.drawingbufferwidth,s.gl.drawingbufferheight)
  s.gl.drawElements(pmTriangles, s.il, s.ib.datatype,0) #0x1403 ??

proc drawArrayAs*(s:State,pm:PrimitiveMode,vertexsize:Natural=4,offset:Natural=0) =
  ## Wrapper for drawArrays
  #s.gl.viewport(0,0,s.gl.drawingbufferwidth,s.gl.drawingbufferheight)
  s.gl.drawArrays(pm, offset,s.vl div vertexsize)


proc drawElementsAs*(s:State,pm:PrimitiveMode) =
  ## Wrappper for drawelements
  #s.gl.viewport(0,0,s.gl.drawingbufferwidth,s.gl.drawingbufferheight)
  s.gl.drawElements(pm, s.il, s.ib.datatype,0) #0x1403 ??

proc attribute*[T:int|float|float32](s:State, name:string, val:openarray[T]) =
  ## Set an attrivute to val.
  let a = s.shader.attributes[name]
  doassert(val.len == ord a.kind, $val.len & " should have been " & $(ord a.kind))
  when T is float:
    s.vb.upload(val)
  elif T is int:
    s.ib.upload(val)

proc uniform*[T:int|float|float32](s:State, name:string, val:openarray[T]) =
  ## Set an uniform to val.
  let un = s.shader.uniforms[name]
  case un.kind:
  of DataKind.Vec1:
    doassert(val.len == 1)
    when T is SomeReal:
      s.gl.uniform1fv(un.location,val.toJSA)
    elif T is int:
      s.gl.uniform1iv(un.location,val.toJSA)
  of DataKind.Vec2:
    doassert(val.len == 2)
    when T is SomeReal:
      s.gl.uniform2fv(un.location,val.toJSA)
    elif T is int:
      s.gl.uniform2iv(un.location,val.toJSA)
  of DataKind.Vec3:
    doassert(val.len == 3)
    when T is SomeReal:
      s.gl.uniform3fv(un.location,val.toJSA)
    elif T is int:
      s.gl.uniform3iv(un.location,val.toJSA)
  of DataKind.Vec4:
    doassert(val.len == 4)
    when T is SomeReal:
      s.gl.uniform4fv(un.location,val.toJSA)
    elif T is int:
      s.gl.uniform4iv(un.location,val.toJSA)
  of DataKind.Mat2:
    doassert(val.len == 4)
    doassert T is SomeReal
    # false-> nomralize?
    s.gl.uniformMatrix2fv(un.location,false,val.toJSA)
  of DataKind.Mat3:
    doassert(val.len == 9)
    doassert T is SomeReal
    # false-> nomralize?
    s.gl.uniformMatrix3fv(un.location,false,val.toJSA)
  of DataKind.Mat4:
    doassert(val.len == 16, "got: "& $val.len)
    doassert T is SomeReal
    s.gl.uniformMatrix4fv(un.location,false,val.toJSA)
  else:
    raise newException(FieldError,"Uniform " & name & ":" & $val & " doesn't match any data layout")

proc `[]=`*[T:int|float|float32](s:State, name:string, val:openarray[T]) =
  ## Set an uniform or buffer to val.
  case s.shader[name]:
  of UnifOrAttr.A:
    s.attribute(name,val)
  of UnifOrAttr.U:
    s.uniform(name,val)

proc `[]=`*[T:int|float](s:State, name:string, u:T) =
  ## Set an uniform to val.
  let un = s.shader.uniforms[name]
  doassert un.kind == DataKind.Vec1
  when T is float:
    s.gl.uniform1f(un.location,u)
  elif T is int:
    s.gl.uniform1i(un.location,u)
  else:
    raise newException(FieldError,"Uniform " & name & ": unknown type")

proc `[]=`*[T:int|float](s:State, name:string, u,v:T) =
  ## Set an uniform to val.
  let un = s.shader.uniforms[name]
  doassert un.kind == DataKind.Vec2
  when T is float:
    s.gl.uniform2f(un.location,u,v)
  elif T is int:
    s.gl.uniform2i(un.location,u,v)
  else:
    raise newException(FieldError,"Uniform " & name & ": unknown type")

proc `[]=`*[T:int|float](s:State, name:string, u,v,w:T) =
  ## Set an uniform to val.
  let un = s.shader.uniforms[name]
  doassert un.kind == DataKind.Vec3
  when T is float:
    s.gl.uniform3f(un.location,u,v,w)
  elif T is int:
    s.gl.uniform3i(un.location,u,v,w)
  else:
    raise newException(FieldError,"Uniform " & name & ": unknown type")

proc `[]=`*[T:int|float](s:State, name:string, u,v,w,t:T) =
  ## Set an uniform to val.
  let un = s.shader.uniforms[name]
  doassert un.kind == DataKind.Vec4
  when T is float:
    s.gl.uniform4f(un.location,u,v,w,t)
  elif T is int:
    s.gl.uniform4i(un.location,u,v,w,t)
  else:
    raise newException(FieldError,"Uniform " & name & ": unknown type")
