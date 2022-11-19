const std = @import("std");
const glfw = @import("libs/mach-glfw/build.zig");
//const gl = @import("src/openglbindings/gl3v3.zig");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("open-patrician", "src/main.zig");

    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addPackage(glfw.pkg);
    exe.install();

    try glfw.link(b, exe, .{});

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the game");
    run_step.dependOn(&run_cmd.step);

    // Not tests for now
    // Some text input from new keyboard
}
