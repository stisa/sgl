import utils, colorattachment,depthattachment
type StoreAction* {.pure.} = enum
  DontCare,
  Store,
  Resolve,
  StoreAndResolve

type PassOptions* = concept p
  p.colorAttachments is ?seq[ColorAttachmentOptions]
  p.depthAttachment is ?DepthAttachmentOptions
  p.storeAction is ?StoreAction

type Pass* = object
  ColorAttachments: seq[ColorAttachment]
  DepthAttachment: DepthAttachment
  StoreAction: StoreAction

proc pass*(o: PassOptions):Pass =
  result.colorAttachments = @[]
  if not(o.colorAttachments.issome) :
      result.colorAttachments.add(colorAttachment())
  else:
    for colAttrs in o.colorAttachments.get :
      result.colorAttachments.add(colorAttachment(colAttrs))

  result.depthAttachment = depthAttachment(get(o.depthAttachment()))
  result.storeAction = get(o.storeAction, StoreAction.DontCare)
    