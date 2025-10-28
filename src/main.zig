// CLI entry point: wires stdin/stdout to the interactive Zorth REPL.
// Later lessons might add CLI switches (e.g. script loading), but this stays
// lean so all learning happens in the interpreter modules.
const std = @import("std");
const zorth = @import("zorth");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var repl = try zorth.Repl.init(gpa.allocator());
    defer repl.deinit();

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    defer stdout_writer.flush() catch {};
    const stdout = &stdout_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;

    try repl.run(stdin, stdout);
}
