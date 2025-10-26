const std = @import("std");
const options = @import("build_options");
const harness = @import("lesson_harness");

test "lesson plan cases" {
    const lesson_number = options.lesson orelse {
        std.debug.print("No lesson selected; rerun with `-Dlesson=<n>`.\n", .{});
        return error.SkipZigTest;
    };
    const lesson = switch (lesson_number) {
        1 => @import("lessons/lesson1.zig").lesson(),
        2 => @import("lessons/lesson2.zig").lesson(),
        3 => @import("lessons/lesson3.zig").lesson(),
        35 => @import("lessons/lesson3_5.zig").lesson(),
        4 => @import("lessons/lesson4.zig").lesson(),
        else => {
            std.debug.print("Unknown lesson {d}\n", .{lesson_number});
            return error.SkipZigTest;
        },
    };

    const DebugAllocator = std.heap.DebugAllocator(.{});
    var gpa = DebugAllocator.init;
    defer _ = gpa.deinit();
    var suite = try harness.Harness.init(gpa.allocator());
    defer suite.deinit();

    try suite.runLesson(lesson);
}
