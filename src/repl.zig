const std = @import("std");
const interpreter_mod = @import("interpreter.zig");

pub const Repl = struct {
    interpreter: interpreter_mod.Interpreter,
    prompt: []const u8 = "ok> ",

    pub fn init(allocator: std.mem.Allocator) !Repl {
        return .{
            .interpreter = try interpreter_mod.Interpreter.init(allocator),
            .prompt = "ok> ",
        };
    }

    pub fn deinit(self: *Repl) void {
        self.interpreter.deinit();
    }

    pub fn run(self: *Repl, reader: anytype, writer: anytype) !void {
        _ = self;
        _ = reader;
        _ = writer;
        // Lesson 1: implement the interactive loop here.
        return interpreter_mod.InterpreterError.Todo;
    }
};
