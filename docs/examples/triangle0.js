/* Generated by the Nim Compiler v0.16.1 */
/*   (c) 2017 Andreas Rumpf */

var framePtr = null;
var excHandler = 0;
var lastJSError = null;
if (typeof Int8Array === 'undefined') Int8Array = Array;
if (typeof Int16Array === 'undefined') Int16Array = Array;
if (typeof Int32Array === 'undefined') Int32Array = Array;
if (typeof Uint8Array === 'undefined') Uint8Array = Array;
if (typeof Uint16Array === 'undefined') Uint16Array = Array;
if (typeof Uint32Array === 'undefined') Uint32Array = Array;
if (typeof Float32Array === 'undefined') Float32Array = Array;
if (typeof Float64Array === 'undefined') Float64Array = Array;
var NTI118 = {size: 0,kind: 42,base: null,node: null,finalizer: null};
var NTI30009 = {size: 0,kind: 16,base: null,node: null,finalizer: null};
var NTI126 = {size: 0,kind: 37,base: null,node: null,finalizer: null};
var NTI30003 = {size: 0,kind: 16,base: null,node: null,finalizer: null};
var NTI3446 = {size: 0, kind: 17, base: null, node: null, finalizer: null};
var NTI3440 = {size: 0, kind: 17, base: null, node: null, finalizer: null};
var NTI104 = {size: 0,kind: 31,base: null,node: null,finalizer: null};
var NTI12809 = {size: 0, kind: 18, base: null, node: null, finalizer: null};
var NTI3408 = {size: 0, kind: 17, base: null, node: null, finalizer: null};
var NTI138 = {size: 0,kind: 28,base: null,node: null,finalizer: null};
var NTI140 = {size: 0,kind: 29,base: null,node: null,finalizer: null};
var NTI3485 = {size: 0,kind: 22,base: null,node: null,finalizer: null};
var NTI3424 = {size: 0, kind: 17, base: null, node: null, finalizer: null};
var NTI3438 = {size: 0, kind: 17, base: null, node: null, finalizer: null};
var NTI3442 = {size: 0, kind: 17, base: null, node: null, finalizer: null};
var NNI3442 = {kind: 2, len: 0, offset: 0, typ: null, name: null, sons: []};
NTI3442.node = NNI3442;
var NNI3438 = {kind: 2, len: 0, offset: 0, typ: null, name: null, sons: []};
NTI3438.node = NNI3438;
NTI3485.base = NTI3424;
var NNI3424 = {kind: 2, len: 4, offset: 0, typ: null, name: null, sons: [{kind: 1, offset: "parent", len: 0, typ: NTI3485, name: "parent", sons: null}, 
{kind: 1, offset: "name", len: 0, typ: NTI140, name: "name", sons: null}, 
{kind: 1, offset: "message", len: 0, typ: NTI138, name: "msg", sons: null}, 
{kind: 1, offset: "trace", len: 0, typ: NTI138, name: "trace", sons: null}]};
NTI3424.node = NNI3424;
var NNI3408 = {kind: 2, len: 0, offset: 0, typ: null, name: null, sons: []};
NTI3408.node = NNI3408;
NTI3424.base = NTI3408;
NTI3438.base = NTI3424;
NTI3442.base = NTI3438;
var NNI12809 = {kind: 2, len: 2, offset: 0, typ: null, name: null, sons: [{kind: 1, offset: "Field0", len: 0, typ: NTI140, name: "Field0", sons: null}, 
{kind: 1, offset: "Field1", len: 0, typ: NTI104, name: "Field1", sons: null}]};
NTI12809.node = NNI12809;
var NNI3440 = {kind: 2, len: 0, offset: 0, typ: null, name: null, sons: []};
NTI3440.node = NNI3440;
NTI3440.base = NTI3438;
var NNI3446 = {kind: 2, len: 0, offset: 0, typ: null, name: null, sons: []};
NTI3446.node = NNI3446;
NTI3446.base = NTI3424;
NTI30003.base = NTI126;
NTI30009.base = NTI118;
function makeNimstrLit(c_13803) {

    var ln = c_13803.length;
    var result = new Array(ln + 1);
    var i = 0;
    for (; i < ln; ++i) {
      result[i] = c_13803.charCodeAt(i);
    }
    result[i] = 0; // terminating zero
    return result;
    }
function SetConstr() {

      var result = {};
      for (var i = 0; i < arguments.length; ++i) {
        var x = arguments[i];
        if (typeof(x) == "object") {
          for (var j = x[0]; j <= x[1]; ++j) {
            result[j] = true;
          }
        } else {
          result[x] = true;
        }
      }
      return result;
    }
function nimCopy(dest_19018, src_19019, ti_19020) {

var result_19429 = null;
switch (ti_19020.kind) {
case 21: case 22: case 23: case 5: if (!(isFatPointer_19001(ti_19020))) {
result_19429 = src_19019;
}
else {
result_19429 = [src_19019[0], src_19019[1]];}


break;
case 19:       if (dest_19018 === null || dest_19018 === undefined) {
        dest_19018 = {};
      }
      else {
        for (var key in dest_19018) { delete dest_19018[key]; }
      }
      for (var key in src_19019) { dest_19018[key] = src_19019[key]; }
      result_19429 = dest_19018;
    
break;
case 18: case 17: if (!((ti_19020.base == null))) {
result_19429 = nimCopy(dest_19018, src_19019, ti_19020.base);
}
else {
if ((ti_19020.kind == 17)) {
result_19429 = (dest_19018 === null || dest_19018 === undefined) ? {m_type: ti_19020} : dest_19018;}
else {
result_19429 = (dest_19018 === null || dest_19018 === undefined) ? {} : dest_19018;}
}
nimCopyAux(result_19429, src_19019, ti_19020.node);

break;
case 24: case 4: case 27: case 16:       if (src_19019 === null) {
        result_19429 = null;
      }
      else {
        if (dest_19018 === null || dest_19018 === undefined) {
          dest_19018 = new Array(src_19019.length);
        }
        else {
          dest_19018.length = src_19019.length;
        }
        result_19429 = dest_19018;
        for (var i = 0; i < src_19019.length; ++i) {
          result_19429[i] = nimCopy(result_19429[i], src_19019[i], ti_19020.base);
        }
      }
    
break;
case 28:       if (src_19019 !== null) {
        result_19429 = src_19019.slice(0);
      }
    
break;
default: 
result_19429 = src_19019;
break;
}
return result_19429;
}
function eqStrings(a_16403, b_16404) {

    if (a_16403 == b_16404) return true;
    if ((!a_16403) || (!b_16404)) return false;
    var alen = a_16403.length;
    if (alen != b_16404.length) return false;
    for (var i = 0; i < alen; ++i)
      if (a_16403[i] != b_16404[i]) return false;
    return true;
  }
function arrayConstr(len_19603, value_19604, typ_19605) {

      var result = new Array(len_19603);
      for (var i = 0; i < len_19603; ++i) result[i] = nimCopy(null, value_19604, typ_19605);
      return result;
    }
function cstrToNimstr(c_14003) {

  var ln = c_14003.length;
  var result = new Array(ln);
  var r = 0;
  for (var i = 0; i < ln; ++i) {
    var ch = c_14003.charCodeAt(i);

    if (ch < 128) {
      result[r] = ch;
    }
    else if((ch > 127) && (ch < 2048)) {
      result[r] = (ch >> 6) | 192;
      ++r;
      result[r] = (ch & 63) | 128;
    }
    else {
      result[r] = (ch >> 12) | 224;
      ++r;
      result[r] = ((ch >> 6) & 63) | 128;
      ++r;
      result[r] = (ch & 63) | 128;
    }
    ++r;
  }
  result[r] = 0; // terminating zero
  return result;
  }
function toJSStr(s_14203) {

    var len = s_14203.length-1;
    var asciiPart = new Array(len);
    var fcc = String.fromCharCode;
    var nonAsciiPart = null;
    var nonAsciiOffset = 0;
    for (var i = 0; i < len; ++i) {
      if (nonAsciiPart !== null) {
        var offset = (i - nonAsciiOffset) * 2;
        var code = s_14203[i].toString(16);
        if (code.length == 1) {
          code = "0"+code;
        }
        nonAsciiPart[offset] = "%";
        nonAsciiPart[offset + 1] = code;
      }
      else if (s_14203[i] < 128)
        asciiPart[i] = fcc(s_14203[i]);
      else {
        asciiPart.length = i;
        nonAsciiOffset = i;
        nonAsciiPart = new Array((len - i) * 2);
        --i;
      }
    }
    asciiPart = asciiPart.join("");
    return (nonAsciiPart === null) ?
        asciiPart : asciiPart + decodeURIComponent(nonAsciiPart.join(""));
  }
function raiseException(e_13206, ename_13207) {

e_13206.name = ename_13207;
if ((excHandler == 0)) {
unhandledException(e_13206);
}

e_13206.trace = nimCopy(null, rawWriteStackTrace_13028(), NTI138);
throw e_13206;}
var nimvm_5887 = false;
var nim_program_result = 0;
var globalRaiseHook_10805 = [null];
var localRaiseHook_10810 = [null];
var outOfMemHook_10813 = [null];
function isFatPointer_19001(ti_19003) {

var result_19004 = false;
BeforeRet: do {
result_19004 = !((SetConstr(17, 16, 4, 18, 27, 19, 23, 22, 21)[ti_19003.base.kind] != undefined));
break BeforeRet;
} while (false); 
return result_19004;
}
function nimCopyAux(dest_19023, src_19024, n_19026) {

switch (n_19026.kind) {
case 0: 
break;
case 1:       dest_19023[n_19026.offset] = nimCopy(dest_19023[n_19026.offset], src_19024[n_19026.offset], n_19026.typ);
    
break;
case 2: L1: do {
var i_19415 = 0;
var colontmp__19417 = 0;
colontmp__19417 = (n_19026.len - 1);
var res_19420 = 0;
L2: do {
L3: while (true) {
if (!(res_19420 <= colontmp__19417)) break L3;
i_19415 = res_19420;
nimCopyAux(dest_19023, src_19024, n_19026.sons[i_19415]);
res_19420 += 1;
}
} while(false);
} while(false);

break;
case 3:       dest_19023[n_19026.offset] = nimCopy(dest_19023[n_19026.offset], src_19024[n_19026.offset], n_19026.typ);
      for (var i = 0; i < n_19026.sons.length; ++i) {
        nimCopyAux(dest_19023, src_19024, n_19026.sons[i][1]);
      }
    
break;
}
}
function add_10829(x_10832, x_10832_Idx, y_10833) {

        var len = x_10832[0].length-1;
        for (var i = 0; i < y_10833.length; ++i) {
          x_10832[0][len] = y_10833.charCodeAt(i);
          ++len;
        }
        x_10832[0][len] = 0
      }
function auxWriteStackTrace_12804(f_12806) {

var Tmp3;
var result_12807 = [null];
var it_12815 = f_12806;
var i_12816 = 0;
var total_12817 = 0;
var tempFrames_12821 = arrayConstr(64, {Field0: null, Field1: 0}, NTI12809);
L1: do {
L2: while (true) {
if (!!((it_12815 == null))) Tmp3 = false; else {Tmp3 = (i_12816 <= 63); }if (!Tmp3) break L2;
tempFrames_12821[i_12816].Field0 = it_12815.procname;
tempFrames_12821[i_12816].Field1 = it_12815.line;
i_12816 += 1;
total_12817 += 1;
it_12815 = it_12815.prev;
}
} while(false);
L4: do {
L5: while (true) {
if (!!((it_12815 == null))) break L5;
total_12817 += 1;
it_12815 = it_12815.prev;
}
} while(false);
result_12807[0] = nimCopy(null, makeNimstrLit(""), NTI138);
if (!((total_12817 == i_12816))) {
if (result_12807[0] != null) { result_12807[0] = (result_12807[0].slice(0, -1)).concat(makeNimstrLit("(")); } else { result_12807[0] = makeNimstrLit("(");};
if (result_12807[0] != null) { result_12807[0] = (result_12807[0].slice(0, -1)).concat(cstrToNimstr(((total_12817 - i_12816))+"")); } else { result_12807[0] = cstrToNimstr(((total_12817 - i_12816))+"");};
if (result_12807[0] != null) { result_12807[0] = (result_12807[0].slice(0, -1)).concat(makeNimstrLit(" calls omitted) ...\x0A")); } else { result_12807[0] = makeNimstrLit(" calls omitted) ...\x0A");};
}

L6: do {
var j_13015 = 0;
var colontmp__13021 = 0;
colontmp__13021 = (i_12816 - 1);
var res_13024 = colontmp__13021;
L7: do {
L8: while (true) {
if (!(0 <= res_13024)) break L8;
j_13015 = res_13024;
add_10829(result_12807, 0, tempFrames_12821[j_13015].Field0);
if ((0 < tempFrames_12821[j_13015].Field1)) {
if (result_12807[0] != null) { result_12807[0] = (result_12807[0].slice(0, -1)).concat(makeNimstrLit(", line: ")); } else { result_12807[0] = makeNimstrLit(", line: ");};
if (result_12807[0] != null) { result_12807[0] = (result_12807[0].slice(0, -1)).concat(cstrToNimstr((tempFrames_12821[j_13015].Field1)+"")); } else { result_12807[0] = cstrToNimstr((tempFrames_12821[j_13015].Field1)+"");};
}

if (result_12807[0] != null) { result_12807[0] = (result_12807[0].slice(0, -1)).concat(makeNimstrLit("\x0A")); } else { result_12807[0] = makeNimstrLit("\x0A");};
res_13024 -= 1;
}
} while(false);
} while(false);
return result_12807[0];
}
function rawWriteStackTrace_13028() {

var result_13030 = null;
if (!((framePtr == null))) {
result_13030 = nimCopy(null, (makeNimstrLit("Traceback (most recent call last)\x0A").slice(0,-1)).concat(auxWriteStackTrace_12804(framePtr)), NTI138);
}
else {
result_13030 = nimCopy(null, makeNimstrLit("No stack traceback available\x0A"), NTI138);
}

return result_13030;
}
function unhandledException(e_13054) {

var Tmp1;
var buf_13055 = /**/[makeNimstrLit("")];
if (!!(eqStrings(e_13054.message, null))) Tmp1 = false; else {Tmp1 = !((e_13054.message[0] == 0)); }if (Tmp1) {
if (buf_13055[0] != null) { buf_13055[0] = (buf_13055[0].slice(0, -1)).concat(makeNimstrLit("Error: unhandled exception: ")); } else { buf_13055[0] = makeNimstrLit("Error: unhandled exception: ");};
if (buf_13055[0] != null) { buf_13055[0] = (buf_13055[0].slice(0, -1)).concat(e_13054.message); } else { buf_13055[0] = e_13054.message;};
}
else {
if (buf_13055[0] != null) { buf_13055[0] = (buf_13055[0].slice(0, -1)).concat(makeNimstrLit("Error: unhandled exception")); } else { buf_13055[0] = makeNimstrLit("Error: unhandled exception");};
}

if (buf_13055[0] != null) { buf_13055[0] = (buf_13055[0].slice(0, -1)).concat(makeNimstrLit(" [")); } else { buf_13055[0] = makeNimstrLit(" [");};
add_10829(buf_13055, 0, e_13054.name);
if (buf_13055[0] != null) { buf_13055[0] = (buf_13055[0].slice(0, -1)).concat(makeNimstrLit("]\x0A")); } else { buf_13055[0] = makeNimstrLit("]\x0A");};
if (buf_13055[0] != null) { buf_13055[0] = (buf_13055[0].slice(0, -1)).concat(rawWriteStackTrace_13028()); } else { buf_13055[0] = rawWriteStackTrace_13028();};
var cbuf_13201 = toJSStr(buf_13055[0]);
framePtr = null;
  if (typeof(Error) !== "undefined") {
    throw new Error(cbuf_13201);
  }
  else {
    throw cbuf_13201;
  }
  }
function raiseOverflow() {

var e_13641 = null;
e_13641 = {m_type: NTI3442, parent: null, name: null, message: null, trace: null};
e_13641.message = nimCopy(null, makeNimstrLit("over- or underflow"), NTI138);
e_13641.parent = null;
raiseException(e_13641, "OverflowError");
}
function raiseDivByZero() {

var e_13659 = null;
e_13659 = {m_type: NTI3440, parent: null, name: null, message: null, trace: null};
e_13659.message = nimCopy(null, makeNimstrLit("division by zero"), NTI138);
e_13659.parent = null;
raiseException(e_13659, "DivByZeroError");
}
var canvas_30001 = /**/[document.getElementById("sgl-canvas")];
function sysFatal_22021(message_22027) {

var F={procname:"sysFatal.sysFatal",prev:framePtr,filename:"lib\\system.nim",line:0};
framePtr = F;
F.line = 2617;
var e_22029 = null;
e_22029 = {m_type: NTI3446, parent: null, name: null, message: null, trace: null};
F.line = 2619;
e_22029.message = nimCopy(null, message_22027, NTI138);
F.line = 2620;
raiseException(e_22029, "AssertionError");
framePtr = F.prev;
}
function raiseAssert_22016(msg_22018) {

var F={procname:"system.raiseAssert",prev:framePtr,filename:"lib\\system.nim",line:0};
framePtr = F;
sysFatal_22021(msg_22018);
framePtr = F.prev;
}
function failedAssertImpl_22039(msg_22041) {

var F={procname:"system.failedAssertImpl",prev:framePtr,filename:"lib\\system.nim",line:0};
framePtr = F;
raiseAssert_22016(msg_22041);
framePtr = F.prev;
}
function getContextWebgl_28957(c_28959) {

var result_28960 = null;
var F={procname:"webgl.getContextWebgl",prev:framePtr,filename:"C:\\Users\\stisa\\.nimble\\pkgs\\webgl-#head\\webgl.nim",line:0};
framePtr = F;
F.line = 425;
result_28960 = c_28959.getContext("webgl");
if ((result_28960 === null)) {
F.line = 426;
result_28960 = c_28959.getContext("experimental-webgl");
}

if (!(!((result_28960 === null)))) {
failedAssertImpl_22039(makeNimstrLit("not isNil(result) "));
}

framePtr = F.prev;
return result_28960;
}
var gl_30002 = /**/[getContextWebgl_28957(canvas_30001[0])];
var vertices_30008 = /**/[nimCopy(null, [-5.0000000000000000e-001, 5.0000000000000000e-001, 0.0, -5.0000000000000000e-001, -5.0000000000000000e-001, 0.0, 5.0000000000000000e-001, -5.0000000000000000e-001, 0.0], NTI30003)];
var indices_30011 = /**/[nimCopy(null, [0, 1, 2], NTI30009)];
var vertex_buffer_30012 = /**/[gl_30002[0].createBuffer()];
gl_30002[0].bindBuffer(34962, vertex_buffer_30012[0]);
gl_30002[0].bufferData(34962, new Float32Array(vertices_30008[0]), 35044);
gl_30002[0].bindBuffer(34962, null);
var Index_Buffer_30047 = /**/[gl_30002[0].createBuffer()];
gl_30002[0].bindBuffer(34963, Index_Buffer_30047[0]);
gl_30002[0].bufferData(34963, new Uint16Array(indices_30011[0]), 35044);
gl_30002[0].bindBuffer(34963, null);
var vertCode_30082 = /**/[makeNimstrLit("attribute vec3 coordinates;void main(void) { gl_Position = vec4(coordinates, 1.0);}")];
var vertShader_30092 = /**/[gl_30002[0].createShader(35633)];
gl_30002[0].shaderSource(vertShader_30092[0], toJSStr(vertCode_30082[0]));
gl_30002[0].compileShader(vertShader_30092[0]);
function getStatus_29029(gl_29031, what_29032) {

var result_29033 = false;
var F={procname:"webgl.getStatus",prev:framePtr,filename:"C:\\Users\\stisa\\.nimble\\pkgs\\webgl-#head\\webgl.nim",line:0};
framePtr = F;
F.line = 446;
result_29033 = gl_29031.getShaderParameter(what_29032, gl_29031.COMPILE_STATUS);framePtr = F.prev;
return result_29033;
}
if (!(getStatus_29029(gl_30002[0], vertShader_30092[0]))) {
console.log("error vs");
}

var fragCode_30096 = /**/[makeNimstrLit("void main(void){gl_FragColor = vec4(0.0, 0.0, 0.0, 0.1);}")];
var fragShader_30106 = /**/[gl_30002[0].createShader(35632)];
gl_30002[0].shaderSource(fragShader_30106[0], toJSStr(fragCode_30096[0]));
gl_30002[0].compileShader(fragShader_30106[0]);
if (!(getStatus_29029(gl_30002[0], fragShader_30106[0]))) {
console.log("error fg");
}

var shaderProgram_30110 = /**/[gl_30002[0].createProgram()];
gl_30002[0].attachShader(shaderProgram_30110[0], vertShader_30092[0]);
gl_30002[0].attachShader(shaderProgram_30110[0], fragShader_30106[0]);
gl_30002[0].linkProgram(shaderProgram_30110[0]);
function getStatus_29034(gl_29036, what_29037) {

var result_29038 = false;
var F={procname:"webgl.getStatus",prev:framePtr,filename:"C:\\Users\\stisa\\.nimble\\pkgs\\webgl-#head\\webgl.nim",line:0};
framePtr = F;
F.line = 448;
result_29038 = gl_29036.getProgramParameter(what_29037, gl_29036.LINK_STATUS);framePtr = F.prev;
return result_29038;
}
if (!(getStatus_29034(gl_30002[0], shaderProgram_30110[0]))) {
console.log("error p");
}

gl_30002[0].useProgram(shaderProgram_30110[0]);
gl_30002[0].bindBuffer(34962, vertex_buffer_30012[0]);
gl_30002[0].bindBuffer(34963, Index_Buffer_30047[0]);
var coord_30134 = /**/[gl_30002[0].getAttribLocation(shaderProgram_30110[0], "coordinates")];
gl_30002[0].vertexAttribPointer(coord_30134[0], 3, 5126, false, 0, 0);
gl_30002[0].enableVertexAttribArray(coord_30134[0]);
gl_30002[0].clearColor(5.0000000000000000e-001, 5.0000000000000000e-001, 5.0000000000000000e-001, 9.0000000000000002e-001);
gl_30002[0].enable(2929);
gl_30002[0].clear(16384);
gl_30002[0].viewport(0, 0, canvas_30001[0].width, canvas_30001[0].height);
gl_30002[0].drawElements(4, 3, 5123, 0);
