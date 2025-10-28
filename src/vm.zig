// Minimal data stack implementation backing the interpreter.
// Lesson 1 will rely on push/pop, Lesson 2 adds underflow-aware integer pushes,
// and later lessons can extend this module with return stacks, memory spaces,
// or tracing helpers without disturbing higher-level code.
const std = @import("std");

pub const VmError = error{
    StackUnderflow,
};

pub const Vm = struct {
    allocator: std.mem.Allocator,
    stack: std.array_list.Managed(i64),

    pub fn init(allocator: std.mem.Allocator) Vm {
        return .{
            .allocator = allocator,
            .stack = std.array_list.Managed(i64).init(allocator),
        };
    }

    pub fn deinit(self: *Vm) void {
        self.stack.deinit();
    }

    pub fn reset(self: *Vm) void {
        self.stack.clearRetainingCapacity();
    }

    pub fn stackSlice(self: *const Vm) []const i64 {
        return self.stack.items;
    }

    pub fn push(self: *Vm, value: i64) !void {
        try self.stack.append(value);
    }

    pub fn pop(self: *Vm) !i64 {
        if (self.stack.popOrNull()) |value| {
            return value;
        }
        return VmError.StackUnderflow;
    }
};
