const std = @import("std");
const vm_mod = @import("vm.zig");
const tokenizer_mod = @import("tokenizer.zig");
const words_mod = @import("words.zig");

pub const Cell = i64;

pub const InterpreterError = error{
    Todo,
    StackUnderflow,
    UnknownWord,
    CompileMode,
};

pub const Interpreter = struct {
    allocator: std.mem.Allocator,
    vm: vm_mod.Vm,
    dictionary: words_mod.Dictionary,
    tokenizer: tokenizer_mod.Tokenizer,
    mode: Mode = .interpret,

    pub const Mode = enum {
        interpret,
        compile,
    };

    pub fn init(allocator: std.mem.Allocator) !Interpreter {
        return .{
            .allocator = allocator,
            .vm = vm_mod.Vm.init(allocator),
            .dictionary = words_mod.Dictionary.init(allocator),
            .tokenizer = tokenizer_mod.Tokenizer{},
        };
    }

    pub fn deinit(self: *Interpreter) void {
        self.vm.deinit();
        self.dictionary.deinit();
    }

    pub fn reset(self: *Interpreter) void {
        self.vm.reset();
        self.dictionary.reset();
        self.mode = .interpret;
    }

    pub fn stackSlice(self: *const Interpreter) []const Cell {
        return self.vm.stackSlice();
    }

    pub fn processLine(self: *Interpreter, line: []const u8, writer: anytype) !void {
        _ = self;
        _ = writer;
        _ = line;
        return InterpreterError.Todo;
    }
};
