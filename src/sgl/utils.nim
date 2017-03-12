import webgl/enums

const VertexFormatMap* :array[
  12,tuple[size:int,dt:DataType,b:bool]
]= [
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
