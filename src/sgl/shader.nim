import webgl
import strutils
import utils

type UnifOrAttr* {.pure.}= enum
  U,A

type DataKind* {.pure.}= enum
  Vec1 = (1,"float")
  Vec2 = (2,"vec2")
  Vec3 = (3,"vec3")
  Vec4 = (4,"vec4")
  Mat3 = (9,"mat3")
  Mat4 = (16,"mat4")
  Unknown = (100,"UNKNOWN")

type Attribute* = object
  name*: string
  location*: uint
  kind*: DataKind
  size*: int
  datatype*:DataType
  normalize*:bool

type Uniform* = object
  location*: WebGLUniformLocation
  name*:string
  kind*: DataKind
  size*: int
  datatype*:DataType
  normalize*:bool

#[
  const VertexFormatMap :array[
  14,tuple[size:int,dt:DataType,b:bool]
  ]= [
  ( 1, dtFLOAT, false ),
  ( 2, dtFLOAT, false ),
  ( 3, dtFLOAT, false ),
  ( 4, dtFLOAT, false ),
  ( 9, dtFLOAT, false ),
  ( 16, dtFLOAT, false ),
  ( 4, dtBYTE, false ),
  ( 4, dtBYTE, true ),
  ( 4, dtUNSIGNED_BYTE, false ),
  ( 4, dtUNSIGNED_BYTE, true ),
  ( 2, dtSHORT, false ),
  ( 2, dtSHORT, true ),
  ( 4, dtSHORT, false ),
  ( 4, dtSHORT, true )
]#
proc attribute(name:string,kind:string):Attribute =
  let k = case kind:
    of $DataKind.Vec1: DataKind.Vec1
    of $DataKind.Vec2: DataKind.Vec2
    of $DataKind.Vec3: DataKind.Vec3
    of $DataKind.Vec4: DataKind.Vec4
    of $DataKind.Mat3: DataKind.Mat3
    of $DataKind.Mat4: DataKind.Mat4
    else : DataKind.Unknown
  let (sz,dt,nrm) = case k:
    of DataKind.Vec1: ( 1, dtFLOAT, false )
    of DataKind.Vec2: ( 2, dtFLOAT, false )
    of DataKind.Vec3: ( 3, dtFLOAT, false )
    of DataKind.Vec4: ( 4, dtFLOAT, false )
    of DataKind.Mat3: ( 9, dtFLOAT, false )
    of DataKind.Mat4: ( 16, dtFLOAT, false )
    else: (0,dtShort,false)
  result = Attribute(name:name,kind:k,datatype:dt,size:sz,normalize:nrm)

proc uniform(name:string,kind:string):Uniform =
  let k = case kind:
    of $DataKind.Vec1: DataKind.Vec1
    of $DataKind.Vec2: DataKind.Vec2
    of $DataKind.Vec3: DataKind.Vec3
    of $DataKind.Vec4: DataKind.Vec4
    of $DataKind.Mat3: DataKind.Mat3
    of $DataKind.Mat4: DataKind.Mat4
    else : DataKind.Unknown
  let (sz,dt,nrm) = case k:
    of DataKind.Vec1: ( 1, dtFLOAT, false )
    of DataKind.Vec2: ( 2, dtFLOAT, false )
    of DataKind.Vec3: ( 3, dtFLOAT, false )
    of DataKind.Vec4: ( 4, dtFLOAT, false )
    of DataKind.Mat3: ( 9, dtFLOAT, false )
    of DataKind.Mat4: ( 16, dtFLOAT, false )
    else: (0,dtShort,false)
    
  result = Uniform(name:name,kind:k,datatype:dt,size:sz,normalize:nrm)

proc extractAttrsAndUnifs(vs,fs:string):tuple[uniforms:seq[Uniform],attributes:seq[Attribute]] =
  result = (uniforms: newseq[Uniform](),
            attributes: newseq[Attribute]())

  for line in vs.splitLines: 
    let splitted = line.strip( chars=WhiteSpace+{';',':'} ).splitWhitespace
    if splitted.len == 3: # Assume three elements per line if it's an attribute or uniform'
      case splitted[0].strip:
      of "attribute":
        result.attributes.add(attribute(splitted[2],splitted[1]))
      of "uniform":
        result.uniforms.add(uniform(splitted[2],splitted[1]))
      else:
        discard #echo("unknown splitted:"& $splitted)
    else: discard #echo("unknown splitted len:"& $splitted)

  for line in fs.splitLines: 
    let splitted = line.strip( chars=WhiteSpace+{';',':'} ).splitWhitespace
    
    if splitted.len == 3: # Assume three elements per line if it's an attribute or uniform'
      case splitted[0].strip:
      of "attribute":
        result.attributes.add(attribute(splitted[2],splitted[1]))
      of "uniform":
        result.uniforms.add(uniform(splitted[2],splitted[1]))
      else:
         discard #echo("unknown splitted:"& $splitted)
    else: discard #echo("unknown splitted len:"& $splitted)

proc `[]`*(list:seq[Attribute],name:string):Attribute =
  ## Search into the list of attributes by name.
  ## Since I don't usually have tons of names, a simple linear search will do
  for ua in list:
    if ua.name == name : return ua
  result = attribute(name,"UNKNOWN") #Nim shuts up about init
  raise newException(FieldError,"Attribute not found: "&name)

proc `[]`*(list:seq[Uniform],name:string):Uniform =
  ## Search into the list of uniforms by name.
  ## Since I don't usually have tons of names, a simple linear search will do
  for ua in list:
    if ua.name == name : return ua
  # If we couldn't find one, raise an error
  result = uniform(name,"UNKNOWN") #Nim shuts up about init
  raise newException(FieldError,"Uniform not found: "&name)

proc point*(gl:WebglRenderingContext,a:Attribute) =
  # Point an attribute to the currently bound VBO
  gl.vertexAttribPointer(a.location, a.size, a.datatype, a.normalize, 0, 0)
  # Enable the attribute
  gl.enableVertexAttribArray(a.location)

type Shader* = object
  glprogram* : WebglProgram
  uniforms*: seq[Uniform]
  attributes*:seq[Attribute]

proc shader*(gl:WebglRenderingContext,vssrc:string=DefaultVS,fssrc:string=DefaultFS,usethis:bool=true):Shader = 

  let vs = gl.createShader(seVertexShader)
  gl.shadersource(vs,vssrc)
  gl.compileShader(vs)
  if not gl.getStatus(vs): echo "error vertex shader"

  let fs = gl.createShader(seFragmentShader)
  gl.shadersource(fs,fssrc)
  gl.compileShader(fs)
  if not gl.getStatus(fs): echo "error fragment shader"
  
  let prog = gl.createProgram()
  gl.attachShader(prog,vs)
  gl.attachShader(prog,fs)
  gl.linkProgram(prog)
  if not gl.getStatus(prog): echo "error linking program"

  let ua = extractAttrsAndUnifs(vssrc,fssrc)
  result.uniforms = ua.uniforms
  result.attributes = ua.attributes
  result.glprogram = prog
  
  gl.deleteShader(vs)
  gl.deleteShader(fs)

  # iterate over the u and a and get their location
  for a in result.attributes.mitems:
    a.location = gl.getAttribLocation(result.glprogram, a.name.cstring)
    assert( a.location.int != -1, "Problems with attribute: "&a.name&", misspelled?")
  for u in result.uniforms.mitems:
    u.location = gl.getUniformLocation(result.glprogram, u.name)
    #TODO: check u.location.int "Problems with uniform"&u.name)
  gl.useProgram(result.glprogram)


proc `[]`*(s:Shader,name:string):UnifOrAttr =
  # Until we can have return based overloading
  var nota :bool
  var notu :bool
  try:
    discard s.uniforms[name]
    result = UnifOrAttr.U
  except:
    notu = true
  try:
    discard  s.attributes[name]
    result = UnifOrAttr.A
  except:
    nota = true
  if nota != notu : return
  else:
    raise newException(FieldError,"Attribute/Uniform not found or found in both: "&name)
   
  