import utils,texture

type LoadAction* {.pure.}= enum
    DontCare,
    Load,
    Clear,

type ColorAttachmentOptions* = object
    texture* : ?Texture
    mipLevel* : ?int
    slice* : ?int
    loadAction* : ?LoadAction
    clearColor* : ?tuple[r,g,b,a:float]

type ColorAttachment* = object
    texture* : Texture
    mipLevel* : int
    slice* : int
    loadAction* : LoadAction
    clearColor* : tuple[r,g,b,a:float]



proc colorattachment*():ColorAttachment =
    ColorAttachment(
        texture: emptyTexture(),
        mipLevel : 0,
        slice : 0,
        loadAction : LoadAction.Clear,
        clearColor : (0.0, 0.0, 0.0, 1.0))


proc colorattachment*(o: ColorAttachmentOptions):ColorAttachment =
    ColorAttachment(texture : o.texture.get,
                    mipLevel : get(o.mipLevel, 0),
                    slice : get(o.slice, 0),
                    loadAction : get(o.loadAction, LoadAction.Clear),
                    clearColor : get(o.clearColor, (0.0, 0.0, 0.0, 1.0)))
