import webgl

import utils

# Describe the Layout of the Vertices passed to a buffer.

type StepFunc* {.pure.}= enum
  ## Whether the described layout is for vertices or elements
  PerVertex,
  PerInstance

type  VertexFormat* {.pure.} = enum
  Float,## 32-bit float, single component in X
  Float2,## 32-bit floats, 2 components in XY 
  Float3,## 32-bit floats, 3 components in XYZ
  Float4,## 32-bit floats, 4 components in XYZW
  Byte4,## 4 packed bytes, signed (-128 .. 127)
  Byte4N,## 4 packed bytes, signed, normalized (-1.0 .. +1.0)
  UByte4,## 4 packed bytes, unsigned (0 .. 255)
  UByte4N,## 4 packed bytes, unsigned, normalized (0.0 .. 1.0)
  Short2,## 2 packed 16-bit shorts, signed (-32767 .. +32768)
  Short2N,## 2 packed 16-bit shorts, signed (-1.0 .. +1.0)
  Short4,## 4 packed 16-bit shorts, signed (-32767 .. +32768)
  Short4N,## 4 packed 16-bit shorts, signed (-1.0 .. +1.0)


type VertexLayout* = object
  components : seq[tuple[name:string,format:VertexFormat]]
  stepFunc : StepFunc
  stepRate : Natural

proc vertexlayout*( comps: seq[tuple[name:string,format:VertexFormat]] ,stepfunc=StepFunc.PerVertex,steprate=1):VertexLayout =
  result.components = comps
  result.stepfunc = stepfunc
  result.steprate = steprate

proc vertexFormatByteSize*(fmt: VertexFormat): int =
  case fmt:
  of  VertexFormat.Float,
      VertexFormat.Byte4,
      VertexFormat.Byte4N,
      VertexFormat.UByte4,
      VertexFormat.UByte4N,
      VertexFormat.Short2,
      VertexFormat.Short2N:
    4
  of  VertexFormat.Float2,
      VertexFormat.Short4,
      VertexFormat.Short4N:
    8
  of VertexFormat.Float3:
    12
  of VertexFormat.Float4:
    16

proc bytesize*(vl:VertexLayout):int =
  for comp in vl.components: result += vertexFormatByteSize(comp[1])

proc componentByteOffset*(vl:VertexLayout, compIndex: int): int =
  for i in 0..<compindex:
    result += vertexFormatByteSize(vl.components[i][1])