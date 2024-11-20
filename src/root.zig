//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");

pub const c = @import("./cbore_core.zig");
pub const CborStream = @import("./CborStream.zig");

test "test entry" {
    std.testing.refAllDecls(@This());
}
