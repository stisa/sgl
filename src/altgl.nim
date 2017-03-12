import webgl
import altgl/[
  buffer,
  colorattachment,
  depthattachment,
  drawstate,
  face,
  pass,
  pipeline,
  shader,
  texture,
  utils,
  vertexlayout
]

type GfxOptions = object
  canvas : string ## name of existing HTML canvas (default: 'canvas') 
  width: int ## new width of canvas (default: don't change canvas width) 
  height: int ## new  height of canvas (default: don't change canvas height) 
  alpha: bool ## whether drawing buffer should have alpha channel (default: true) 
  depth: bool ## whether drawing buffer should have a depth buffer (default: true) 
  stencil: bool ## whether drawing buffer should have a stencil buffer (default: false) 
  antiAlias: bool ## whether drawing buffer should be anti-aliased (default: true) 
  preMultipliedAlpha: bool ## whether drawing buffer contains pre-multiplied-alpha colors (default: true) 
  preserveDrawingBuffer: bool ## whether content of drawing buffer should be preserved (default: false) 
  preferLowPowerToHighPerformance: bool ## whether to create a context for low-power-consumption (default: false) 
  failIfMajorPerformanceCaveat: bool ## whether context creation fails if performance would be low (default: false) 
  highDPI: bool ## whether to create a high-resolution context on Retina-type displays (default: false) 