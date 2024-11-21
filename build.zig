const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    @import("set_version").VersionSetterStep.addStep(b);

    const dep_cobore_core = b.dependency("cbor_source", .{});

    const lib_core = b.addStaticLibrary(.{
        .name = "CborCore",
        .target = target,
        .optimize = optimize,
    });
    lib_core.addIncludePath(dep_cobore_core.path("include"));
    lib_core.addCSourceFiles(.{
        .root = dep_cobore_core.path("src/"),
        .files = &.{
            "encoder.c",
            "common.c",
            "decoder.c",
            "parser.c",
            "ieee754.c",
        }
    });
    lib_core.installHeadersDirectory(dep_cobore_core.path("include/cbor"), "cbor", .{});
    lib_core.linkLibC();
    b.installArtifact(lib_core);

    const mod_cbor_stream = b.addModule("zig-cbor-stream", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod_cbor_stream.addIncludePath(dep_cobore_core.path("include"));
    mod_cbor_stream.linkLibrary(lib_core);

    const mod_cbor_stream_test = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod_cbor_stream_test.addIncludePath(dep_cobore_core.path("include"));
    mod_cbor_stream_test.linkLibC();
    mod_cbor_stream_test.linkLibrary(lib_core);
    
    const run_lib_unit_tests = b.addRunArtifact(mod_cbor_stream_test);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&b.addInstallArtifact(mod_cbor_stream_test, .{.dest_sub_path = "../test/test-cbor-stream"}).step);
}
