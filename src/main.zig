const std = @import("std");
const zorth = @import("zorth");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var repl = try zorth.Repl.init(gpa.allocator());
    defer repl.deinit();

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    try repl.run(stdin, stdout);
}
