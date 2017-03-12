import ../src/altgl
import options
# create the AltGL object which initializes
# a WebGL context and the default render state

let gfx = altgl( AltGLOptions( width: 400.some, height: 300.some, canvas: "triangle-canvas".some ) )

# create a render-pass
let pass = gfx.makePass(
    PassOptions( 
        colorAttachments: @[ ColorAttachmentOptions( clearColor: (0.5, 0.5, 0.5, 1.0).some ) ].some
        )
    )

# a vertex buffer with positions and colors for a triangle
let vertexBuffer = gfx.makeBuffer({
    Type: altai.BufferType.VertexBuffer,
    Data: new Float32Array([
        # positions        colors
        0.0, 0.5, 0.5,      1.0, 0.0, 0.0, 1.0,
        0.5, -0.5, 0.5,     0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0.5,    0.0, 0.0, 1.0, 1.0,
    ]),
});

# create a vertex/fragment shader pair
let shader = gfx.makeShader({
    VertexShader: `
        attribute vec4 position;
        attribute vec4 color;
        varying lowp vec4 vColor;
        void main(void) {
            gl_Position = position;
            vColor = color;
        }`,
    FragmentShader: `
        varying lowp vec4 vColor;
        void main(void) {
            gl_FragColor = vColor;
        }`
});

# the pipeline-state object 
let pipeline = gfx.makePipeline({
    VertexLayouts: [{
        Components: [
            [ "position", altai.VertexFormat.Float3 ],
            [ "color", altai.VertexFormat.Float4 ],
        ]
    }],
    Shader: shader,
    DepthCmpFunc: altai.CompareFunc.Always,
    DepthWriteEnabled: false,
    CullFaceEnabled: false,
});

# putting it all together in a draw-state object
let drawState = gfx.makeDrawState({
    Pipeline: pipeline,
    VertexBuffers: [ vertexBuffer ],
});

# the per-frame draw-function
function draw() {
    gfx.beginPass(pass);
    gfx.applyDrawState(drawState);
    gfx.draw(0, 3);
    gfx.endPass();
    gfx.commitFrame(draw);
}
draw();
