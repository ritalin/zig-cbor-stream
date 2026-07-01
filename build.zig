const std = @import("std");

pub fn build(b: *std.Build) void {
    @import("set_version").VersionSetterStep.addStep(b);

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dep_cobore_core = b.dependency("cbor_source", .{});

    const mod_cbore_core = b.addModule("cbor-core", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    mod_cbore_core.addIncludePath(dep_cobore_core.path("include"));
    mod_cbore_core.addCSourceFiles(.{
        .root = dep_cobore_core.path("src/"),
        .files = &.{
            "encoder.c",
            "common.c",
            "decoder.c",
            "parser.c",
            "ieee754.c",
        }
    });
    
    const lib_core = b.addLibrary(.{
        .name = "CborCore",
        .root_module = mod_cbore_core,
    });
    lib_core.installHeadersDirectory(dep_cobore_core.path("include/cbor"), "cbor", .{});
    b.installArtifact(lib_core);

    const mod_tc = b.addTranslateC(.{
        .root_source_file = dep_cobore_core.path("include/cbor/cbor.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    mod_tc.addIncludePath(dep_cobore_core.path("include"));

    const mod_cbor_stream = b.addModule("cbor-stream", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "cbor_core", .module = mod_tc.createModule() },
        },
    });
    mod_cbor_stream.linkLibrary(lib_core);

    const mod_cbor_stream_test = b.addTest(.{
        .root_module = mod_cbor_stream,
    });
    mod_cbor_stream_test.root_module.linkLibrary(lib_core);

    const run_lib_unit_tests = b.addRunArtifact(mod_cbor_stream_test);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&b.addInstallArtifact(mod_cbor_stream_test, .{.dest_sub_path = "../test/test-cbor-stream"}).step);
}
