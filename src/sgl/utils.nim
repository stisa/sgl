from webgl import Canvas,Float32Array,Uint16Array,Int32Array

type Bufferables* = openarray[uint|int|float|float32|uint16|int32]
type IndexBufferables* = openarray[uint|int|uint16|int32]
type VertexBufferables* = openarray[float|float32]

const DefaultVS* =  """
attribute vec4 aPosition;
uniform mat4 uMatrix;
void main() {
  gl_Position = uMatrix*aPosition;
}
"""

const DefaultFS* = """
#ifdef GL_ES
  precision highp float;
#endif

uniform vec4 uColor;
void main() {
  gl_FragColor = uColor;
}
"""

proc jenkins_one_at_a_time_hash(key:string):int =
  var hash = 0
  for c in key:
    hash += c.int
    hash += hash shl 10
    hash = hash xor ( hash shr 6)

  hash += hash shl 3;
  hash =  hash xor (hash shr 11)
  hash += hash shl 15;
  return hash

proc `$`* [T](x:openarray[T]):string =
  result = "["
  for i in 0..<x.len:
    if i>0:
      add result, ", "
    add result, $x[i]
  add result, "]"

proc resizeToDisplaySize*(c:Canvas, pixelratio:float=1):bool {.discardable.} =
  ## Resize the canvas to display size.
  ## Returns true if a resize occurred.
  let multiplier = max(1, pixelratio)
  var width  = c.clientWidth  * multiplier.int
  var height = c.clientHeight * multiplier.int
  if (c.width != width or
      c.height != height):
    c.width = width
    c.height = height
    result = true
  result = false

proc toJSA*(v:openarray[float32]) :Float32Array {.importcpp: "new Float32Array(#)".} # might be a lie
proc toJSA*(v:openarray[float]) :Float32Array {.importcpp: "new Float32Array(#)".} # might be a lie
proc toJSA*(v:openarray[uint16]) :Uint16Array {.importcpp: "new Uint16Array(#)".} # might be a lie
proc toJSA*(v:openarray[int32]) :Int32Array {.importcpp: "new Uint16Array(#)".} # might be a lie
proc toJSA*(v:openarray[int]) :Int32Array {.importcpp: "new Int32Array(#)".} # might be a lie
