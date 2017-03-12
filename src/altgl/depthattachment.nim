import texture,colorattachment,utils

type DepthAttachmentOptions* = object
  texture : ?Texture
  loadAction : ?LoadAction
  clearDepth : ?float
  clearStencil : ?int

type DepthAttachment* = object
  texture*: Texture
  loadAction*: LoadAction
  clearDepth*: float
  clearStencil*: int

proc depthattachment*():DepthAttachment =
  result.loadAction = LoadAction.Clear
  result.clearDepth = 1.0
  result.clearStencil = 0

proc depthattachment*(o: DepthAttachmentOptions):DepthAttachment =
  result.texture = get(o.texture, emptyTexture())
  result.loadAction = get(o.loadAction, LoadAction.Clear)
  result.clearDepth = get(o.clearDepth, 1.0)
  result.clearStencil = get(o.clearStencil, 0)