{.warning[ProveInit]:off.}
from webgl import Canvas,Float32Array,Uint16Array,Int32Array
from dom import Window
from math import cos,sin,degtorad
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

proc devicePixelRatio*(w:Window):float {.importcpp:"#.devicePixelRatio".}

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

proc projection2*(w,h:float):array[4,float] =
  result[0] = 2/w
  result[3] = 2/h

proc projection3*(w,h:float):array[9,float] =
  result[0] = 2/w
  result[4] = 2/h
  result[6] = -1
  result[7] = -1
  result[8] = 1

proc rotation3*(theta:float):array[9,float] =
  result[0] = cos(degtorad(theta))
  result[1] = sin(degtorad(theta))
  result[3] = -sin(degtorad(theta))
  result[4] = cos(degtorad(theta))
  result[8] = 1

proc rotation3X*(theta:float):array[9,float] =
  result[4] = cos(degtorad(theta))
  result[5] = sin(degtorad(theta))
  result[7] = -sin(degtorad(theta))
  result[8] = cos(degtorad(theta))
  result[0] = 1

proc rotation3Y*(theta:float):array[9,float] =
  result[0] = cos(degtorad(theta))
  result[2] = -sin(degtorad(theta))
  result[6] = sin(degtorad(theta))
  result[8] = cos(degtorad(theta))
  result[4] = 1

proc rotation4Y*(theta:float):array[16,float] =
  result[0] = cos(degtorad(theta))
  result[2] = -sin(degtorad(theta))
  result[8] = sin(degtorad(theta))
  result[10] = cos(degtorad(theta))
  result[5] = 1
  result[15] = 1

proc scale3*(sx=1.0,sy:float=1.0):array[9,float] =
  # Row-major+post multiply
  result[0] = sx
  result[4] = sy
  result[8] = 1

proc translation3*(dx=0.0,dy:float=0.0):array[9,float] =
  # Row-major+post multiply
  result[0] = 1
  result[4] = 1
  result[6] = dx
  result[7] = dy
  result[8] = 1

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


template newFpsCounter*(onID:string = "body"){.dirty}=
  ## Setup an fps counter as a child of element "onID"
  ## You then need to call `updateFpsCounter`:idx:
  ## to update.
  # FIXME: not sure about reported fps.
  import dom
  from times import epochtime

  var fpsPrevTime = 0.0
  var fpsFrames = 0
 
  proc appendFpsCounter*(toID:string="body") =
    var fel = document.createElement("P")
    fel.innerHTML = "FPS Counter"
    #proc setAttribute*(n: Node, name, value: cstring)
    fel.setAttribute("ID","_fpsCounter_")
    fel.setAttribute("STYLE","position:relative;top:-2em;left:1em;border:0.1em solid black; max-width:5em;text-align:right;background-color:ghostwhite; z-index:10;")
    if toID=="body":
      document.body.appendChild(fel)
    else:
      var parent = document.getElementById(toID)
      if parent.isnil: parent = document.getElementById("body")
      parent.appendChild(fel)
  fpsPrevTime = epochtime()
  appendFpsCounter(onID)

  proc updateFpsCounter*() =
    var fpsCounter = dom.document.getElementById("_fpsCounter_")
    inc fpsFrames
    let time = times.epochTime()
    if time > fpsPrevTime+1:
      let fps= int(fps_frames.float / (time - fpsPrevTime))
      fpsCounter.innerHTML = $fps & " FPS"
      fpsprevtime = time
      fps_frames = 0
