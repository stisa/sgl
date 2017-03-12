import utils,webgl

import shader,vertexlayout

type PrimitiveMode {.pure.} = enum
  Points = pmPoints
  Lines = pmLines
  LineStrip = pmLineStrip
  Triangles = pmTriangles
  TriangleStrip = pmTriangleStrip

type IndexFormat {.pure.} = enum
  None = 0
  UShort = dtUnsignedShort
  UInt = dtUnsignedInt

type BlendFactor {.pure.} = enum
  ZERO = 0 # Passed to blendFunc or blendFuncSeparate to turn off a component. 
  ONE = 1 # Passed to blendFunc or blendFuncSeparate to turn on a component. 
  SRC_COLOR = 0x0300 # Passed to blendFunc or blendFuncSeparate to multiply a component by the source elements color. 
  ONE_MINUS_SRC_COLOR = 0x0301 # Passed to blendFunc or blendFuncSeparate to multiply a component by one minus the source elements color. 
  SRC_ALPHA = 0x0302 # Passed to blendFunc or blendFuncSeparate to multiply a component by the source's alpha. 
  ONE_MINUS_SRC_ALPHA = 0x0303 # Passed to blendFunc or blendFuncSeparate to multiply a component by one minus the source's alpha. 
  DST_ALPHA = 0x0304 # Passed to blendFunc or blendFuncSeparate to multiply a component by the destination's alpha. 
  ONE_MINUS_DST_ALPHA = 0x0305 # Passed to blendFunc or blendFuncSeparate to multiply a component by one minus the destination's alpha. 
  DST_COLOR = 0x0306 # Passed to blendFunc or blendFuncSeparate to multiply a component by the destination's color. 
  ONE_MINUS_DST_COLOR = 0x0307 # Passed to blendFunc or blendFuncSeparate to multiply a component by one minus the destination's color. 
  SRC_ALPHA_SATURATE = 0x0308 # Passed to blendFunc or blendFuncSeparate to multiply a component by the minimum of source's alpha or one minus the destination's alpha. 
  Blend_COLOR = 0x8001 # Passed to blendFunc or blendFuncSeparate to specify a constant color blend function. 
  ONE_MINUS_Blend_COLOR = 0x8002 # Passed to blendFunc or blendFuncSeparate to specify one minus a constant color blend function. 
  Blend_ALPHA = 0x8003 # Passed to blendFunc or blendFuncSeparate to specify a constant alpha blend function. 
  ONE_MINUS_Blend_ALPHA = 0x8004 # Passed to blendFunc or blendFuncSeparate to specify one minus a constant alpha blend function. 

type BlendOp {.pure.} = enum
  #Constants passed to WebGLRenderingContext.blendEquation() or WebGLRenderingContext.blendEquationSeparate() to control how the blending is calculated (for both, RBG and alpha, or separately).
  ADD = 0x8006 # Passed to blendEquation or blendEquationSeparate to set an addition blend function. 
  SUBSTRACT = 0x800A # Passed to blendEquation or blendEquationSeparate to specify a subtraction blend function (source - destination). 
  REVERSE_SUBTRACT = 0x800B # Passed to blendEquation or blendEquationSeparate to specify a reverse subtraction blend function (destination - source). 

type Face {.pure.} = enum
  Front = 0x0404 ## cull front side 
  Back = 0x0405  ## cull back side 
  Both = 0x0408  ## cull both sides 

type StencilOp {.pure.} = enum
  Zero = 0,
  ## set the stencil value to zero 
  Invert = 0x150A,
  ## perform a logical bitwise invert operation on the stencil value 
  Keep = 0x1E00,
  ## keep the current stencil value 
  Replace = 0x1E01,
  ## replace the stencil value with stencil reference value 
  IncrClamp = 0x1E02,
  ## increment the current stencil value, clamp to max 
  DecrClamp = 0x1E03,
  ## decrement the current stencil value, clamp to zero 
  IncrWrap = 0x8507,
  ## increment the current stencil value, with wrap-around 
  DecrWrap = 0x8508,
  ## decrement the current stencil value, with wrap-around 

type CompareFunc {.pure.} = enum
  Never = 0x0200,
  ## new value never passes comparion test 
  Less = 0x0201,
  ## new value passses if it is less than the existing value 
  Equal = 0x0202,
  ## new value passes if it is equal to existing value 
  LessEqual = 0x0203,
  ## new value passes if it is less than or equal to existing value 
  Greater = 0x0204,
  ## new value passes if it is greater than existing value 
  NotEqual = 0x0205,
  ## new value passes if it is not equal to existing value 
  GreaterEqual = 0x0206,
  ## new value passes if it is greater than or equal to existing value 
  Always = 0x0207,
  ## new value always passes 

type PipelineOptions = concept p
  p.vertexLayouts is seq[VertexLayoutOptions]
  ## described the structure of input vertex data 
  p.shader() is Shader
  ## the shader object, with matching vertex inputs 
  p.primitivemode is ?PrimitiveMode
  ## rendering primitive type (triangle, triangle strip, lines, ..)
  p.indexformat is ?IndexFormat
  ## index data format (none, 16- or 32-bit) 
  
  p.blendenabled is ?bool
  ## is alpha-blending enabled? (default: false) 
  p.blendsrcfactor is ?BlendFactor
  ## the blend source factor (both RGB and Alpha, default: One) 
  p.BlendDstFactor is ?BlendFactor
  ## the blend destination factor (both RGB and Alpha, default: Zero) 
  p.blendop is ?BlendOp
  ## the blend operation (both RGB and Alpha, default: Add) 
  p.colorWriteMask is ?tuple[r,g,b,a:bool]
  ## what color-channels to write (default: all true) 
  p.blendColor is ?tuple[r,g,b,a:float]
  ## blend-constant color (default: all 1.0) 
  
  p.blendSrcFactorRGB is  ?BlendFactor
  ## separate RGB blend source factor (default: One) 
  p.blendDstFactorRGB is ?BlendFactor
  ## separate RGB blend destination factor (default: Zero) 
  p.blendOpRGB is ?BlendOp
  ## separate RGB blend operation (default: Add) 
  
  p.blendSrcFactorAlpha ?BlendFactor
  ## separate Alpha blend source factor (default: One) 
  p.blendDstFactorAlpha is ?BlendFactor
  ## separate Alpha blend destination factor (default: Zero) 
  p.blendOpAlpha is ?BlendOp
  ## separate Alpha blend operation (default: Add) 
  
  p.stencilEnabled is ?bool
  ## stencil operations enabled? (default: false) 
  p.stencilFailOp is ?StencilOp
  ## common front/back stencil-fail operation (default: Keep) 
  p.stencilDepthFailOp is ?StencilOp
  ## common front/back stencil-depth-fail operation (default: Keep) 
  p.stencilPassOp is ?StencilOp
  ## common front/back stencil-pass operation (default: Keep) 
  p.stencilCmpFunc is ?CompareFunc
  ## common front/back stencil-compare function (default: Always) 
  p.stencilReadMask is ?int
  ## common front/back stencil read mask (default: 0xFF) 
  p.stencilWriteMask is ?int
  ## common front/back stencil write mask (default: 0xFF) 
  p.stencilRef is ?int
  ## common front/back stencil ref value (default: 0) 
  
  p.frontStencilFailOp is ?StencilOp
  ## separate front stencil-fail operation (default: Keep) 
  p.frontStencilDepthFailOp is ?StencilOp
  ## separate front stencil-depth-fail operation (default: Keep) 
  p.frontStencilPassOp is ?StencilOp
  ## separate front stencil-pass operation (default: Keep) 
  p.frontStencilCmpFunc is ?CompareFunc
  ## separate front stencil-compare function (default: Always) 
  p.frontStencilReadMask is ?int
  ## separate front stencil read mask (default: 0xFF) 
  p.frontStencilWriteMask is ?int
  ## separate front stencil write mask (default: 0xFF) 
  p.frontStencilRef is ?int
  ## separate front stencil ref value (default: 0) 
  
  p.backStencilFailOp is ?StencilOp
  ## separate back stencil-fail operation (default: Keep) 
  p.backStencilDepthFailOp is ?StencilOp
  ## separate back stencil-depth-fail operation (default: Keep) 
  p.backStencilPassOp is ?StencilOp
  ## separate back stencil-pass operation (default: Keep) 
  p.backStencilCmpFunc is ?CompareFunc
  ## separate back stencil-compare function (default: Always) 
  p.backStencilReadMask is ?int
  ## separate back stencil read mask (default: 0xFF) 
  p.backStencilWriteMask is ?int
  ## separate back stencil write mask (default: 0xFF) 
  p.backStencilRef is ?int
  ## separate back stencil ref value (default: 0) 
  
  p.depthCmpFunc is ?CompareFunc
  ## depth-compare function (default: Always) 
  p.depthWriteEnabled is ?bool
  ## depth-writes enabled? (default: false) 
  
  p.cullFaceEnabled is ?bool
  ## face-culling enabled? (default: false) 
  p.cullFace is ?Face
  ## face side to be culled (default: Back) 
  p.scissorTestEnabled is ?bool
  ## scissor test enabled? (default: false) 

type PipelineState = object
  blendEnabled: bool
  blendSrcFactorRGB: BlendFactor
  blendDstFactorRGB: BlendFactor
  blendOpRGB: BlendOp
  blendSrcFactorAlpha: BlendFactor
  blendDstFactorAlpha: BlendFactor
  blendOpAlpha: BlendOp
  colorWriteMask: tuple[r,g,b,a:bool]
  blendColor: tuple[r,g,b,a:float]

  stencilEnabled: bool

  frontStencilFailOp: StencilOp
  frontStencilDepthFailOp: StencilOp
  frontStencilPassOp: StencilOp
  frontStencilCmpFunc: CompareFunc
  frontStencilReadMask: int
  frontStencilWriteMask: int
  frontStencilRef: int

  backStencilFailOp: StencilOp
  backStencilDepthFailOp: StencilOp
  backStencilPassOp: StencilOp
  backStencilCmpFunc: CompareFunc
  backStencilReadMask: int
  backStencilWriteMask: int
  backStencilRef: int

  depthCmpFunc: CompareFunc
  depthWriteEnabled: bool

  cullFaceEnabled: bool
  cullFace: Face
  scissorTestEnabled: bool
  
proc pipelinestate(o:PipelineOptions):PipelineState =
  result.blendEnabled = get(o.blendEnabled, false);
  result.blendSrcFactorRGB = get3(o.blendSrcFactorRGB, o.blendSrcFactor, BlendFactor.One)
  result.blendDstFactorRGB = get3(o.blendDstFactorRGB, o.blendDstFactor, BlendFactor.Zero)
  result.blendOpRGB = get3(o.blendOpRGB, o.blendOp, BlendOp.Add)
  result.blendSrcFactorAlpha = get3(o.blendSrcFactorAlpha, o.blendSrcFactor, BlendFactor.One)
  result.blendDstFactorAlpha = get3(o.blendDstFactorAlpha, o.blendDstFactor, BlendFactor.Zero)
  result.blendOpAlpha = get3(o.blendOpAlpha, o.blendOp, BlendOp.Add)
  result.colorWriteMask = get(o.colorWriteMask, (true, true, true, true))
  result.blendColor = get(o.blendColor, (1.0, 1.0, 1.0, 1.0))

  result.stencilEnabled = get(o.stencilEnabled, false)

  result.frontStencilFailOp = get3(o.frontStencilFailOp, o.stencilFailOp, StencilOp.Keep)
  result.frontStencilDepthFailOp = get3(o.frontStencilDepthFailOp, o.stencilDepthFailOp, StencilOp.Keep)
  result.frontStencilPassOp = get3(o.frontStencilPassOp, o.stencilPassOp, StencilOp.Keep)
  result.frontStencilCmpFunc = get3(o.frontStencilCmpFunc, o.stencilCmpFunc, CompareFunc.Always)
  result.frontStencilReadMask = get3(o.frontStencilReadMask, o.stencilReadMask, 0xFF)
  result.frontStencilWriteMask = get3(o.frontStencilWriteMask, o.stencilWriteMask, 0xFF)
  result.frontStencilRef = get3(o.frontStencilRef, o.stencilRef, 0)

  result.backStencilFailOp = get3(o.backStencilFailOp, o.stencilFailOp, StencilOp.Keep)
  result.backStencilDepthFailOp = get3(o.backStencilDepthFailOp, o.stencilDepthFailOp, StencilOp.Keep)
  result.backStencilPassOp = get3(o.backStencilPassOp, o.stencilPassOp, StencilOp.Keep)
  result.backStencilCmpFunc = get3(o.backStencilCmpFunc, o.stencilCmpFunc, CompareFunc.Always)
  result.backStencilReadMask = get3(o.backStencilReadMask, o.stencilReadMask, 0xFF)
  result.backStencilWriteMask = get3(o.backStencilWriteMask, o.stencilWriteMask, 0xFF)
  result.backStencilRef = get3(o.backStencilRef, o.stencilRef, 0)

  result.depthCmpFunc = get(o.depthCmpFunc, CompareFunc.Always)
  result.depthWriteEnabled = get(o.depthWriteEnabled, false)

  result.cullFaceEnabled = get(o.cullFaceEnabled, false)
  result.cullFace = get(o.cullFace, Face.Back)
  result.scissorTestEnabled = get(o.scissorTestEnabled, false)

type GlAttrib = object
  enabled: bool
  vbIndex: int
  divisor: int
  stride: int
  size: int
  normalized: bool
  offset: int
  kind: int # Attributekind?? enum?

proc glAttrib():GLAttrib = discard

type Pipeline* = object
  vertexlayout: seq[VertexLayout]
  shader: Shader
  primitivemode: PrimitiveMode
  state: PipelineState
  glAttribs: seq[GLAttrib]
  indexFormat: IndexFormat
  indexSize: int

proc pipeline*(o:PipelineOptions):Pipeline = 
  result.vertexLayouts = @[]
  for vlOpt in o.vertexLayouts:
      result.vertexLayouts.add(vertexLayout(vlOpt))
  
  result.shader = o.shader;
  result.primitiveMode = get(o.primitiveMode, PrimitiveMode.Triangles)
  result.state = pipelineState(o)
  result.glAttribs = @[]
  for i in 0..<100: # MaxNumVertexAttribs
      result.glAttribs.add(glAttrib());
  
  result.indexFormat = get(o.indexFormat, IndexFormat.None)
  case (result.indexFormat) :
  of IndexFormat.UShort: result.indexSize = 2
  of IndexFormat.UInt: result.indexSize = 4
  else: result.indexSize = 0