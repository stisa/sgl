import utils, colorattachment,depthattachment
type StoreAction* {.pure.} = enum
  DontCare,
  Store,
  Resolve,
  StoreAndResolve

type PassOptions* = object
  colorAttachments* : ?seq[ColorAttachmentOptions]
  depthAttachment* : ?DepthAttachmentOptions
  storeAction* : ?StoreAction

type Pass* = object
  colorAttachments*: seq[ColorAttachment]
  depthAttachment*: DepthAttachment
  storeAction*: StoreAction

proc pass*(o: PassOptions):Pass =
  result.colorAttachments = @[]
  if not(o.colorAttachments.issome) :
      result.colorAttachments.add(colorAttachment())
  else:
    for colAttrs in o.colorAttachments.get :
      result.colorAttachments.add(colorAttachment(colAttrs))

  result.depthAttachment = depthAttachment(get(o.depthAttachment))
  result.storeAction = get(o.storeAction, StoreAction.DontCare)
    