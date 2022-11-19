const std = @import("std");
const warn = std.debug.warn;
const panic = std.debug.panic;
const glfw = @import("glfw");
const gl = @import("openglbindings/gl3v3.zig");

const WIDTH: i32 = 800;
const HEIGHT: i32 = 600;
// var RUN_ENGINE: bool = true;

// Math constructs for engine graphics
const Vec2 = struct {
    x: f64,
    y: f64,

    pub fn init(x: f64, y: f64) Vec2 {
        return Vec2{
            .x = x,
            .y = y,
        };
    }
};

const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn init(x: f64, y: f64, z: f64) Vec3 {
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

// Debug switch
const DEBUG = true;

// Key callback function
fn keyCallback(window: glfw.Window, key: glfw.Key, scancode: i32, action: glfw.Action, mods: glfw.Mods) void {
    // _ = window;
    // _ = key;
    _ = scancode;
    _ = action;
    _ = mods;

    if (key == glfw.Key.escape) {
        //RUN_ENGINE = false;
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
    const window = try glfw.Window.create(WIDTH, HEIGHT, "Open Patrician - pre-alpha version.", null, null, .{});
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
