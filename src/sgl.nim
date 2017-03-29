##[

`sgl/state <sgl/state.html>`_  the only thing exported from `sgl`. Handles the state of the rendering context. If you want more controls, look below.

`sgl/buffer <sgl/buffer.html>`_ a light wrapper around buffers. Provides upload and bind procs.

`sgl/shader <sgl/shader.html>`_ handles creation of shaders and provides access to uniforms/attributes

`sgl/utils <sgl/utils.html>`_ misc utilities: math, converters, etc.

]##

{.warning[ProveInit]:off.}
import sgl/state
from webgl/enums import PrimitiveMode
from webgl import requestAnimationFrame #TODO: use dom
export state
export PrimitiveMode
export requestAnimationFrame