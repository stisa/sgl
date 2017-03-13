import webgl, dom
import shader,buffer,utils

type State* = object
  vb: Buffer # VertexBuffer
  ib: Buffer # IndexBuffer
  shader: Shader
  il : Natural # Indices len
  vl : Natural # Vertices len


proc state*(gl:WebglRenderingContext,vs,fs:string):State =
  let vb = gl.buffer(BufferKind.Vertex)
  let ib = gl.buffer(BufferKind.Index)
  let shd = gl.shader(vs,fs)
  
  gl.clearColor(0.5, 0.5, 0.5, 0.9);
  gl.enable(0x0B71);
  gl.clear(bbColor);
  gl.canvas.resizeToDisplaySize()
  gl.viewport(0,0,gl.canvas.width,gl.canvas.height);
  
  bindBuffers(vb,ib)
  
  State(vb:vb,ib:ib,shader:shd,il:0,vl:0)

proc upload*(s: var State,vertices:VertexBufferables,indices:IndexBufferables) =
  s.vb.upload(vertices)
  s.ib.upload(indices)
  bindBuffers(s.vb,s.ib)
  s.il = indices.len
  s.vl = vertices.len

proc point*(s:State,name:string) =
  var coord = s.shader.attributes[name] #shd.attributes["coordinates"]
  s.vb.gl.point(coord)

proc drawAsTriangle*(s:State) =
  s.vb.gl.drawElements(pmTriangles, s.il, s.ib.datatype,0) #0x1403 ??