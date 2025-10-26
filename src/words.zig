const std = @import("std");
const vm_mod = @import("vm.zig");

pub const Word = struct {
    name: []const u8,
    behavior: Behavior,

    pub const Behavior = union(enum) {
        builtin: *const fn (*vm_mod.Vm) anyerror!void,
        user_defined: []const []const u8,
    };
};

pub const Dictionary = struct {
    allocator: std.mem.Allocator,
    words: std.array_list.Managed(Word),

    pub fn init(allocator: std.mem.Allocator) Dictionary {
        return .{
            .allocator = allocator,
            .words = std.array_list.Managed(Word).init(allocator),
        };
    }

    pub fn deinit(self: *Dictionary) void {
        self.words.deinit();
    }

    pub fn reset(self: *Dictionary) void {
        self.words.clearRetainingCapacity();
        // Lesson 3+: re-register builtins here.
    }

    pub fn find(self: *const Dictionary, name: []const u8) ?Word {
        for (self.words.items) |word| {
            if (std.mem.eql(u8, word.name, name)) {
                return word;
            }
        }
        return null;
    }

    pub fn addWord(self: *Dictionary, name: []const u8, behavior: Word.Behavior) !void {
        try self.words.append(.{ .name = name, .behavior = behavior });
    }
};
