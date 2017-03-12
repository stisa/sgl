import options
export options

import webgl/enums

template `?`*(typ:untyped):untyped = Option[typ]

template optional*(ty,body:untyped):untyped = 
  # TODO: how to check instantiation context
  
  #type VertexLayoutOptions* = concept v
  #  v.components is openarray[tuple[name:string,format:VertexFormat]]
  #  optional StepFunc:
  #    v.stepfunc
  when compiles(body):
    body is ty
  else:discard

const VertexFormatMap* = [
  ( 1, dtFLOAT, false ),
  ( 2, dtFLOAT, false ),
  ( 3, dtFLOAT, false ),
  ( 4, dtFLOAT, false ),
  ( 4, dtBYTE, false ),
  ( 4, dtBYTE, true ),
  ( 4, dtUNSIGNED_BYTE, false ),
  ( 4, dtUNSIGNED_BYTE, true ),
  ( 2, dtSHORT, false ),
  ( 2, dtSHORT, true ),
  ( 4, dtSHORT, false ),
  ( 4, dtSHORT, true )
]