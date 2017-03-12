import utils,texture

type LoadAction* {.pure.}= enum
    DontCare,
    Load,
    Clear,

type ColorAttachmentOptions* = concept c
    c.texture is ?Texture
    c.mipLevel is ?int
    c.slice is ?int
    c.loadAction is ?LoadAction;
    c.clearColor is ?tuple[r,g,b,a:float]

type ColorAttachment* = object
    texture : Texture
    mipLevel : int
    slice : int
    loadAction : LoadAction
    clearColor : tuple[r,g,b,a:float]



proc colorattachment*():ColorAttachment =
    result.mipLevel = 0
    result.slice = 0
    result.loadAction = LoadAction.Clear
    result.clearColor = (0.0, 0.0, 0.0, 1.0)


proc colorattachment*(o: ColorAttachmentOptions):ColorAttachment =
    result.texture = get(o.texture, Texture())
    result.mipLevel = get(o.mipLevel, 0)
    result.slice = get(o.slice, 0)
    result.loadAction = get(o.loadAction, LoadAction.Clear)
    result.clearColor = get(o.clearColor, (0.0, 0.0, 0.0, 1.0))
