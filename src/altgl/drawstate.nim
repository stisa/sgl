import utils,pipeline,buffer,texture

type DrawStateOptions* = concept d
  p.pipe is Pipeline
  p.vertexBuffers is seq[Buffer]
  p.indexBuffer is ?Buffer
  p.textures is ?seq[Texture]

type DrawState* = object
  pipe : Pipeline
  vertexBuffers : seq[Buffer]
  indexBuffer : Buffer
  textures : seq[Texture]

proc drawstate*(o:DrawStateOptions):DrawState=
  result.pipe = o.pipe
  result.vertexbuffers = o.vertexbuffers
  result.indexbuffer = o.indexbuffer.get(nil)
  result.textures = o.textures.get(@[])
