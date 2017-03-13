from webgl import Canvas
  
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