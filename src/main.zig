const std = @import("std");
const warn = std.debug.warn;
const panic = std.debug.panic;
const glfw = @import("glfw");
const gl = @import("openglbindings/gl3v3.zig");

const WIDTH: i32 = 800;
const HEIGHT: i32 = 600;

// Engine control variables
// var RUN_ENGINE: bool = true;

// Math constructs for engine graphics
const Vec2 = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vec2 {
        return Vec2{
            .x = x,
            .y = y,
        };
    }
};

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec2{
            .x = x,
            .y = y,
            .z = z,
        };
    }
};

// Shaders
const vert_shader: []const u8 =
    \\#version 330
    \\uniform mat4 MVP;
    \\in vec3 vCol;
    \\in vec3 vPos;
    \\out vec3 color;
    \\void main()
    \\{
    \\  gl_Position = MVP * vec(vPos, 0.0, 1.0);
    \\  color = vCol;
    \\}
;
const frag_shader: []const u8 =
    \\#version 330
    \\in vec3 color;
    \\out vec4 fragment;
    \\void main()
    \\{
    \\  fragment = vec4(color, 1.0);
    \\}
;

// Define data for triangle
const Vertex = struct {
    x: f32,
    y: f32,
    r: f32,
    g: f32,
    b: f32,
};

// Triangle vertices
const vertices = [3]Vertex{
    Vertex{ .x = -0.6, .y = -0.4, .r = 1.0, .g = 0.0, .b = 0.0 },
    Vertex{ .x = 0.6, .y = -0.4, .r = 0.0, .g = 1.0, .b = 0.0 },
    Vertex{ .x = 0.0, .y = 0.6, .r = 0.0, .g = 0.0, .b = 1.0 },
};

// Debug switch
const DEBUG = true;

// Key callback function
fn keyCallback(window: glfw.Window, key: glfw.Key, scancode: i32, action: glfw.Action, mods: glfw.Mods) void {
    // _ = window;
    // _ = key;
    _ = scancode;
    _ = action;
    _ = mods;

    // Exit engine
    if (key == glfw.Key.escape) {
        window.setShouldClose(true);
    }
}

fn mouseClickCallback(window: glfw.Window, button: glfw.MouseButton, action: glfw.Action, mods: glfw.Mods) void {
    _ = window;
    _ = button;
    _ = action;
    _ = mods;
}

fn mouseCursorPositionCallback(window: glfw.Window, xpos: f64, ypos: f64) void {
    _ = window;
    _ = xpos;
    _ = ypos;
}

// zig-opengl
fn glGetProcAddress(p: glfw.GLProc, proc: [:0]const u8) ?gl.FunctionPointer {
    _ = p;
    return glfw.getProcAddress(proc);
}

pub fn main() !u8 {
    // Print out version - for development right now
    const version: i32 = 0;
    const stdout = std.io.getStdOut().writer();
    const proc: glfw.GLProc = undefined;

    try stdout.print("Open Patrician - pre-alpha version {d}.\n", .{version});

    // Glfw init
    try glfw.init(.{});
    defer glfw.terminate();

    // Mach opengl
    // You set up window hints inside this structure
    const window = try glfw.Window.create(WIDTH, HEIGHT, "Open Patrician - pre-alpha version.", null, null, .{
        .resizable = false,
        .context_version_major = 3,
        .context_version_minor = 3,
    });
    defer window.destroy();

    // Make window current context
    try glfw.makeContextCurrent(window);

    // Loading GLProc
    try gl.load(proc, glGetProcAddress);

    // Set key callback
    window.setKeyCallback(keyCallback);
    window.setMouseButtonCallback(mouseClickCallback);
    window.setCursorPosCallback(mouseCursorPositionCallback);

    // Waiting for closing the window
    while (!window.shouldClose()) {
        try glfw.pollEvents();

        // Screen cleaning
        gl.clearColor(1, 0, 1, 1);
        gl.clear(gl.COLOR_BUFFER_BIT);

        try window.swapBuffers();
    }

    return 0;
}
