const std = @import("std");
const zorth = @import("zorth");

const HarnessError = error{
    TestFailure,
    TestExpectedError,
    TestUnexpectedError,
};

pub const Case = struct {
    name: []const u8,
    token_input: ?[]const u8 = null,
    expected_tokens: []const []const u8 = &.{},
    script: ?[]const u8 = null,
    expected_stdout: []const u8 = "",
    expected_stack: ?[]const i64 = null,
    expected_error: ?[]const u8 = null,
};

pub const Lesson = struct {
    number: u8,
    title: []const u8,
    cases: []const Case,
};

pub const Harness = struct {
    allocator: std.mem.Allocator,
    interpreter: zorth.Interpreter,
    stdout_buffer: std.array_list.AlignedManaged(u8, null),

    pub fn init(allocator: std.mem.Allocator) !Harness {
        return .{
            .allocator = allocator,
            .interpreter = try zorth.Interpreter.init(allocator),
            .stdout_buffer = std.array_list.Managed(u8).init(allocator),
        };
    }

    pub fn deinit(self: *Harness) void {
        self.interpreter.deinit();
        self.stdout_buffer.deinit();
    }

    pub fn reset(self: *Harness) void {
        self.interpreter.reset();
        self.stdout_buffer.clearRetainingCapacity();
    }

    pub fn runLesson(self: *Harness, lesson: Lesson) !void {
        for (lesson.cases) |case| {
            try self.runCase(case);
        }
    }

    pub fn runCase(self: *Harness, case: Case) !void {
        self.reset();

        if (case.token_input) |input| {
            var tokens = std.array_list.Managed([]const u8).init(self.allocator);
            defer tokens.deinit();
            const tokenizer = zorth.tokenizer.Tokenizer{};
            var iter = tokenizer.iterator(input);
            while (iter.next()) |token| {
                try tokens.append(token);
            }
            try expectTokens(case, tokens.items);
        }

        if (case.script) |script| {
            try self.runScript(script, case.expected_error);
        }

        if (case.expected_stdout.len > 0) {
            try expectString(case.name, case.expected_stdout, self.stdout_buffer.items);
        }

        if (case.expected_stack) |expected_stack| {
            try expectStack(expected_stack, self.interpreter.stackSlice());
        }
    }

    fn runScript(self: *Harness, script: []const u8, expected_error: ?[]const u8) !void {
        const writer = self.stdout_buffer.writer();
        var lines = std.mem.splitScalar(u8, script, '\n');
        var last_error: ?[]const u8 = null;

        while (lines.next()) |line| {
            if (line.len == 0) continue;
            if (self.interpreter.processLine(line, writer)) |_| {
                continue;
            } else |err| {
                last_error = @errorName(err);
                break;
            }
        }

        if (expected_error) |expected| {
            if (last_error) |actual| {
                try expectString("error", expected, actual);
            } else {
                std.debug.print(
                    "expected error '{s}' but the interpreter succeeded\n",
                    .{expected},
                );
                return HarnessError.TestExpectedError;
            }
        } else if (last_error) |unexpected| {
            std.debug.print("unexpected interpreter error: {s}\n", .{unexpected});
            return HarnessError.TestUnexpectedError;
        }
    }
};

fn expectTokens(case: Case, actual: []const []const u8) !void {
    try std.testing.expectEqual(case.expected_tokens.len, actual.len);
    for (case.expected_tokens, actual) |expected, observed| {
        try expectString(case.name, expected, observed);
    }
}

fn expectStack(expected: []const i64, actual: []const i64) !void {
    try std.testing.expectEqual(expected.len, actual.len);
    for (expected, actual) |exp, observed| {
        try std.testing.expectEqual(exp, observed);
    }
}

fn expectString(label: []const u8, expected: []const u8, actual: []const u8) !void {
    if (!std.mem.eql(u8, expected, actual)) {
        std.debug.print(
            "expectation '{s}' failed.\nexpected: \"{s}\"\nactual:   \"{s}\"\n",
            .{ label, expected, actual },
        );
        return HarnessError.TestFailure;
    }
}
