from buffer import Usage
import utils

type TextureKind {.pure.} = enum
  TwoD = 0x0DE1
  ThreeD = 0x8513

type Filter {.pure.} = enum
  Neares = 0x0DE1
  Linear = 0x8513

type Wrap {.pure.} = enum
  Repeat = 0x2901
  ClampToEdge = 0x812F
  MirroredRepeat = 0x8370

type SamplerState = object
    wrapU : Wrap
    wrapV : Wrap
    wrapW : Wrap
    magFilter : Filter
    minFilter : Filter
    mipFilter : Filter


type PixelFormat {.pure.} = enum
    NONE,## undefined/none/unused 
    RGBA8,## RGBA with 8 bits per channel 
    RGB8,## RGB with 8 bits per channel 
    RGBA4,## RGBA with 4 bits per channel 
    RGB565,## RGB with 5/6/5 bits per channel 
    RGB5_A1,## RGBA with 5-bit color channels, and 1-bit alpha 
    RGB10_A2,## RGBA with 10-bits color channels and 1-bit alpha 
    RGBA32F,## RGBA with 32-bit floating point channels 
    RGBA16F,## RGBA with 16-bit floating point channels 
    R32F,## R component only, 32-bit floating point 
    R16F,## R component only, 16-bit floating point 

type DepthStencilFormat {.pure.}= enum
    DEPTH, ## depth-only
    DEPTHSTENCIL ## combined depth-stencil

type Texture* = object
  kind* : ?TextureKind
  width* : ?int
  height* : ?int
  depth* : ?int
  colorFormat* : ?PixelFormat
  depthStencilFormat* : ?DepthStencilFormat
  usage* : ?Usage
  renderTarget* : ?bool
  generateMipMaps* : ?bool
  sampleCount* : ?int
  sampler* : ?SamplerState


proc emptyTexture*():Texture =
  result.kind = some(TextureKind.TwoD)