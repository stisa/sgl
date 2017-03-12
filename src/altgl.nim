import webgl except PrimitiveMode
import dom

from webgl/consts import ScissorTest,StencilTest,Blend,CullFace

import altgl/[
  buffer,
  colorattachment,
  depthattachment,
  drawstate,
  pass,
  pipeline,
  shader,
  texture,
  utils,
  vertexlayout
]
export buffer,
  colorattachment,
  depthattachment,
  drawstate,
  pass,
  pipeline,
  shader,
  texture,
  utils,
  vertexlayout

const MaxNumColorAttachments = 4;
const MaxNumVertexAttribs = 16;

type AltglOptions* = object
  canvas* : ?string ## name of existing HTML canvas (default: 'canvas') 
  width*: ?int ## new width of canvas (default: don't change canvas width) 
  height*: ?int ## new  height of canvas (default: don't change canvas height) 
  alpha: ?bool ## whether drawing buffer should have alpha channel (default: true) 
  depth: ?bool ## whether drawing buffer should have a depth buffer (default: true) 
  stencil: ?bool ## whether drawing buffer should have a stencil buffer (default: false) 
  antiAlias: ?bool ## whether drawing buffer should be anti-aliased (default: true) 
  preMultipliedAlpha: ?bool ## whether drawing buffer contains pre-multiplied-alpha colors (default: true) 
  preserveDrawingBuffer: ?bool ## whether content of drawing buffer should be preserved (default: false) 
  preferLowPowerToHighPerformance: ?bool ## whether to create a context for low-power-consumption (default: false) 
  failIfMajorPerformanceCaveat: ?bool ## whether context creation fails if performance would be low (default: false) 
  highDPI: ?bool ## whether to create a high-r
  
type Altgl = object
  gl : WebGLRenderingContext
  cache: PipelineState
  curProgram: WebGLProgram
  curIndexFormat: IndexFormat
  curIndexSize: int
  curPrimMode: PrimitiveMode

proc makePass*(a:Altgl,o:PassOptions):Pass = pass(o)

proc makeBuffer*(a:Altgl,o:BufferOptions):Buffer = 
  result = buffer(o,a.gl.createBuffer())
  a.gl.bindbuffer(result.kind,result.glbuffer)
  if o.data.issome:
    a.gl.bufferData(result.kind,o.data,result.usage)
  elif o.len.issome:
    a.gl.bufferData(result.kind,o.len,result.usage)

proc makeShader*(a:Altgl,o:ShaderOptions):Shader = 
  let vs = a.gl.createShader(seVertexShader)
  a.gl.shadersource(vs,o.vertexshader.cstring)
  a.gl.compileShader(vs)
  if not a.gl.getStatus(vs): echo "error vertex shader"

  let fs = a.gl.createShader(seFragmentShader)
  a.gl.shadersource(vs,o.fragmentshader.cstring)
  a.gl.compileShader(fs)
  if not a.gl.getStatus(fs): echo "error fragment shader"
  
  let prog = a.gl.createProgram()
  a.gl.attachShader(prog,vs)
  a.gl.attachShader(prog,fs)
  a.gl.linkProgram(prog)
  if not a.gl.getStatus(prog): echo "error linking program"
  
  result = shader(prog)
  
  a.gl.deleteShader(vs)
  a.gl.deleteShader(fs)

proc makePipeline*(a:AltGL,options: PipelineOptions): Pipeline =
  result = pipeline(options)
  for layoutindex in 0..<result.vertexlayout.len:
    let layout = result.vertexLayouts[layoutIndex]
    let layoutByteSize = layout.byteSize()
    for compIndex in 0..<layout.components.len:
      let comp = layout.components[compIndex];
      let attrName = comp[0];
      let attrFormat = comp[1];
      let attrIndex = a.gl.getAttribLocation(result.shader.glProgram, attrName)
      if (attrIndex != -1) :
        var attrib = result.glAttribs[attrIndex]
        attrib.enabled = true
        attrib.vbIndex = layoutIndex
        attrib.divisor = if layout.stepFunc == StepFunc.PerVertex : 0 else : layout.stepRate
        attrib.stride = layoutByteSize
        attrib.offset = layout.componentByteOffset(compIndex)
        attrib.size   = VertexFormatMap[attrFormat][0]
        attrib.type   = VertexFormatMap[attrFormat][1]
        attrib.normalized = VertexFormatMap[attrFormat][2]
      
      else:
        echo("Attribute '", attrName, "' not found in shader!")
  
proc makeDrawState*(a:AltGL,options: DrawStateOptions): DrawState = drawstate(options)

proc applyState(a: var AltGL,state: PipelineState, force: bool) =
  # apply depth-stencil state changes
  if (force or (a.cache.depthCmpFunc != state.depthCmpFunc)) :
      a.cache.depthCmpFunc = state.depthCmpFunc;
      a.gl.depthFunc(state.depthCmpFunc.uint);
  
  if (force or (a.cache.depthWriteEnabled != state.depthWriteEnabled)) :
      a.cache.depthWriteEnabled = state.depthWriteEnabled;
      a.gl.depthMask(state.depthWriteEnabled);
  
  if (force or (a.cache.stencilEnabled != state.stencilEnabled)) :
      a.cache.stencilEnabled = state.stencilEnabled;
      if (state.stencilEnabled): a.gl.enable(STENCIL_TEST)
      else: a.gl.disable(STENCIL_TEST)
  
  var sCmpFunc = state.frontStencilCmpFunc
  var sReadMask = state.frontStencilReadMask
  var sRef = state.frontStencilRef
  if (force or 
      (a.cache.frontStencilCmpFunc != sCmpFunc) or
      (a.cache.frontStencilReadMask != sReadMask) or
      (a.cache.frontStencilRef != sRef)) :                
      a.cache.frontStencilCmpFunc = sCmpFunc
      a.cache.frontStencilReadMask = sReadMask
      a.cache.frontStencilRef = sRef
      a.gl.stencilFuncSeparate(Face.FRONT.uint, sCmpFunc.uint, sRef, sReadMask.uint)
  
  sCmpFunc = state.backStencilCmpFunc;
  sReadMask = state.backStencilReadMask;
  sRef = state.backStencilRef;
  if (force or 
      (a.cache.backStencilCmpFunc != sCmpFunc) or
      (a.cache.backStencilReadMask != sReadMask) or
      (a.cache.backStencilRef != sRef)):                
      a.cache.backStencilCmpFunc = sCmpFunc;
      a.cache.backStencilReadMask = sReadMask;
      a.cache.backStencilRef = sRef;
      a.gl.stencilFuncSeparate(Face.BACK.uint, sCmpFunc.uint, sRef, sReadMask.uint)
  
  var sFailOp = state.frontStencilFailOp;
  var sDepthFailOp = state.frontStencilDepthFailOp;
  var sPassOp = state.frontStencilPassOp;
  if (force or
      (a.cache.frontStencilFailOp != sFailOp) or
      (a.cache.frontStencilDepthFailOp != sDepthFailOp) or
      (a.cache.frontStencilPassOp != sPassOp)):    
      a.cache.frontStencilFailOp = sFailOp;
      a.cache.frontStencilDepthFailOp = sDepthFailOp;
      a.cache.frontStencilPassOp = sPassOp;
      a.gl.stencilOpSeparate(Face.FRONT.uint, sFailOp.uint, sDepthFailOp.uint, sPassOp.uint)
  
  sFailOp = state.backStencilFailOp;
  sDepthFailOp = state.backStencilDepthFailOp;
  sPassOp = state.backStencilPassOp;
  if (force or
      (a.cache.backStencilFailOp != sFailOp) or
      (a.cache.backStencilDepthFailOp != sDepthFailOp) or
      (a.cache.backStencilPassOp != sPassOp)):    
      a.cache.backStencilFailOp = sFailOp
      a.cache.backStencilDepthFailOp = sDepthFailOp
      a.cache.backStencilPassOp = sPassOp
      a.gl.stencilOpSeparate(Face.BACK.uint, sFailOp.uint, sDepthFailOp.uint, sPassOp.uint)
  
  if (force or (a.cache.frontStencilWriteMask != state.frontStencilWriteMask)) :
      a.cache.frontStencilWriteMask = state.frontStencilWriteMask
      a.gl.stencilMaskSeparate(Face.FRONT.uint, state.frontStencilWriteMask.uint)
  
  if (force or (a.cache.backStencilWriteMask != state.backStencilWriteMask)) :
      a.cache.backStencilWriteMask = state.backStencilWriteMask
      a.gl.stencilMaskSeparate(Face.BACK.uint, state.backStencilWriteMask.uint)
  

  # apply blend state changes
  if (force or (a.cache.blendEnabled != state.blendEnabled)) :
      a.cache.blendEnabled = state.blendEnabled
      a.gl.enable(BLEND)
  
  if (force or
      (a.cache.blendSrcFactorRGB != state.blendSrcFactorRGB) or
      (a.cache.blendDstFactorRGB != state.blendDstFactorRGB) or
      (a.cache.blendSrcFactorAlpha != state.blendSrcFactorAlpha) or
      (a.cache.blendDstFactorAlpha != state.blendDstFactorAlpha)):
      a.cache.blendSrcFactorRGB = state.blendSrcFactorRGB;
      a.cache.blendDstFactorRGB = state.blendDstFactorRGB;
      a.cache.blendSrcFactorAlpha = state.blendSrcFactorAlpha;
      a.cache.blendDstFactorAlpha = state.blendDstFactorAlpha;
      a.gl.blendFuncSeparate(state.blendSrcFactorRGB.uint, 
                                state.blendDstFactorRGB.uint, 
                                state.blendSrcFactorAlpha.uint, 
                                state.blendDstFactorAlpha.uint)
   
  if (force or
      (a.cache.blendOpRGB != state.blendOpRGB) or
      (a.cache.blendOpAlpha != state.blendOpAlpha)):
      a.cache.blendOpRGB = state.blendOpRGB;
      a.cache.blendOpAlpha = state.blendOpAlpha;
      a.gl.blendEquationSeparate(state.blendOpRGB.uint, state.blendOpAlpha.uint)
  
  if (force or 
      (a.cache.colorWriteMask[0] != state.colorWriteMask[0]) or
      (a.cache.colorWriteMask[1] != state.colorWriteMask[1]) or
      (a.cache.colorWriteMask[2] != state.colorWriteMask[2]) or
      (a.cache.colorWriteMask[3] != state.colorWriteMask[3])):
      a.cache.colorWriteMask[0] = state.colorWriteMask[0];
      a.cache.colorWriteMask[1] = state.colorWriteMask[1];
      a.cache.colorWriteMask[2] = state.colorWriteMask[2];
      a.cache.colorWriteMask[3] = state.colorWriteMask[3];
      a.gl.colorMask(state.colorWriteMask[0], 
                        state.colorWriteMask[1], 
                        state.colorWriteMask[2],
                        state.colorWriteMask[3]);
  
  if (force or 
      (a.cache.blendColor[0] != state.blendColor[0]) or
      (a.cache.blendColor[1] != state.blendColor[1]) or
      (a.cache.blendColor[2] != state.blendColor[2]) or
      (a.cache.blendColor[3] != state.blendColor[3])):
      a.cache.blendColor[0] = state.blendColor[0];
      a.cache.blendColor[1] = state.blendColor[1];
      a.cache.blendColor[2] = state.blendColor[2];
      a.cache.blendColor[3] = state.blendColor[3];
      a.gl.blendColor(state.blendColor[0],
                          state.blendColor[1],
                          state.blendColor[2],
                          state.blendColor[3]);
  

  # apply rasterizer state
  if (force or (a.cache.cullFaceEnabled != state.cullFaceEnabled)) :
      a.cache.cullFaceEnabled = state.cullFaceEnabled
      if (state.cullFaceEnabled): a.gl.enable(CULL_FACE.uint)
      else: a.gl.disable(CULL_FACE.uint)
  
  if (force or (a.cache.cullFace != state.cullFace)) :
      a.cache.cullFace = state.cullFace;
      a.gl.cullFace(state.cullFace.uint);
  
  if (force or (a.cache.scissorTestEnabled != state.scissorTestEnabled)) :
      a.cache.scissorTestEnabled = state.scissorTestEnabled;
      if (state.scissorTestEnabled): a.gl.enable(SCISSOR_TEST)
      else: a.gl.disable(SCISSOR_TEST)
  
proc beginPass(a: var AltGL,pass: Pass) =
  const isDefaultPass: bool = true#not pass.colorAttachments[0].texture
  #/*
  #const width = isDefaultPass ? a.gl.canvas.width : pass.colorAttachment[0].texture.width;
  #const height = isDefaultPass ? a.gl.canvas.height : pass.colorAttachment[0].texture.height;
  #*/
  let width = a.gl.canvas.width;
  let height = a.gl.canvas.height;

  # FIXME: bind offscreen framebuffer or default framebuffer

  # prepare clear operations
  a.gl.viewport(0, 0, width, height)
  a.gl.disable(SCISSOR_TEST)
  a.gl.colorMask(true, true, true, true)
  a.gl.depthMask(true)
  a.gl.stencilMask(0xFF)

  # update cache
  a.cache.scissorTestEnabled = false
  a.cache.colorWriteMask[0] = true
  a.cache.colorWriteMask[1] = true
  a.cache.colorWriteMask[2] = true
  a.cache.colorWriteMask[3] = true
  a.cache.depthWriteEnabled = true
  a.cache.frontStencilWriteMask = 0xFF
  a.cache.backStencilWriteMask = 0xFF

  if (isDefaultPass) :
      var clearMask :uint= 0
      let col : ColorAttachment = pass.colorAttachments[0]
      let dep = pass.depthAttachment
      if (col.loadAction == LoadAction.Clear):
          clearMask = clearmask or bbColor.uint
          a.gl.clearColor(col.clearColor[0], col.clearColor[1], col.clearColor[2], col.clearColor[3]);
      
      if (dep.loadAction == LoadAction.Clear):
          clearMask = clearmask or bbDEPTH.uint or bbSTENCIL.uint
          a.gl.clearDepth(dep.clearDepth)
          a.gl.clearStencil(dep.clearStencil)
      
      if (0.uint != clearMask) :
          a.gl.clear(clearMask)
  else :
      discard

# TODO  endPass()

proc applyViewPort(a:AltGL, x,y,width,height:int) =
        a.gl.viewport(x, y, width, height)

proc applyScissorRect(a:AltGL, x,y,width,height:int) =
        a.gl.scissor(x, y, width, height)

proc applyDrawState(a: var AltGL,drawState: DrawState) =

        a.curPrimMode = drawState.pipeline.primitiveMode

        # update render state
        a.applyState(drawState.pipeline.state, false)

        # apply shader program
        if (a.curProgram != drawState.pipeline.shader.glProgram) :
            a.curProgram = drawState.pipeline.shader.glProgram
            a.gl.useProgram(a.curProgram)

        # apply index and vertex data
        a.curIndexFormat = drawState.pipeline.indexFormat
        a.curIndexSize = drawState.pipeline.indexSize;
        a.gl.bindBuffer(BufferKind.Index.uint, drawState.indexBuffer.glbuffer);
        var curVB: WebGLBuffer = nil
        for attrIndex  in 0..<MaxNumVertexAttribs:
            let attrib = drawState.pipeline.glAttribs[attrIndex]
            # FIXME: implement a state cache for vertex attrib bindings
            if (attrib.enabled):
                if (drawState.vertexBuffers[attrib.vbIndex].glbuffer != curVB) :
                    curVB = drawState.vertexBuffers[attrib.vbIndex].glBuffer
                    a.gl.bindBuffer(BufferKind.Vertex.uint, curVB);
                
                a.gl.vertexAttribPointer(attrIndex.uint, attrib.size, attrib.kind.uint, attrib.normalized, attrib.stride, attrib.offset);
                a.gl.enableVertexAttribArray(attrIndex.uint);
                # FIMXE: WebGL2 vertex attrib divisor!
            else :
                a.gl.disableVertexAttribArray(attrIndex.uint)
            
proc applyUniform(name: string, x: int) = discard

proc draw*(a:AltGL,baseElement, numElements: int, numInstances: int = 1) =
        if (IndexFormat.None == a.curIndexFormat) :
            # non-indexed rendering
            if (1 == numInstances) :
                a.gl.drawArrays(a.curPrimMode.uint, baseElement, numElements)
            
            else :discard
                # FIXME: instanced rendering!
        else: 
            # indexed rendering
            let indexOffset = baseElement * a.curIndexSize;
            if (1 == numInstances) :
                a.gl.drawElements(a.curPrimMode.uint, numElements, a.curIndexFormat.uint, indexOffset)
            
            else : discard
                # FIXME: instanced rendering!

proc commitFrame*(a:AltGL,fn:proc(dt:float)) = requestAnimationFrame(fn)          

proc altgl*(options: AltglOptions):Altgl =
  let glContextAttrs = (
      alpha: get(options.alpha, true),
      depth: get(options.depth, true),
      stencil: get(options.stencil, false),
      antialias: get(options.antiAlias, true),
      premultipliedAlpha: get(options.preMultipliedAlpha, true),
      preserveDrawingBuffer: get(options.preserveDrawingBuffer, false),
      preferLowPowerToHighPerformance: get(options.preferLowPowerToHighPerformance, false),
      failIfMajorPerformanceCaveat: get(options.failIfMajorPerformanceCaveat, false)
  )
  var canvas = document.getElementById(get(options.canvas, "canvas")).Canvas
  if (options.width.issome):        
      canvas.width = options.width.get
  
  if (options.height.issome):
      canvas.height = options.height.get

  result.gl = canvas.getContext("webgl")  #, glContextAttrs)
  if result.gl.isnil:
    result.gl = canvas.getContext("experimental-webgl")  #, glContextAttrs))
  result.gl.viewport(0, 0, canvas.width, canvas.height);

  result.cache = pipelineState()
  result.applyState(result.cache, true)