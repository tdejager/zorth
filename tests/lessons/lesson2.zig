// Spec cases for Lesson 2; exercises integer parsing, printing, and errors.
// Future numeric features (e.g. signed/hex parsing) should add cases here so
// the lesson narrative remains in sync with behavior.
const harness = @import("lesson_harness");

// Lesson 2 — Integer Handling + Print
// Why:
// - The data stack is central to Forth, so we must parse integers and move them through the stack.
// - Displaying results with `.` makes the REPL feel interactive and exposes stack effects.
// - Unknown words and stack underflow need graceful errors for a friendly learning loop.
//
// What to Build:
// - Parse integers from input and push them onto the stack.
// - Implement `.` to pop the top value and print it.
// - Emit clear errors for unknown words and underflow situations.
//
// Tests (behavior expectations):
// - `2` results in a stack holding `[2]`.
// - `2 3` pushes both numbers, leaving `[2, 3]`.
// - `.` after pushing `3` prints `3` and leaves `[2]`.
// - `.` on an empty stack reports a stack underflow error.
// - `foo` leaves the stack untouched and reports `Unknown word: foo`.

pub fn lesson() harness.Lesson {
    return .{
        .number = 2,
        .title = "Integer Handling + Print",
        .cases = &.{
            .{
                .name = "single integer push",
                .script = "2\n",
                .expected_stack = &.{ 2 },
            },
            .{
                .name = "multiple integers",
                .script = "2 3\n",
                .expected_stack = &.{ 2, 3 },
            },
            .{
                .name = "dot prints top of stack",
                .script = "2 3 .\n",
                .expected_stack = &.{ 2 },
                .expected_stdout =
                \\ok> 2 3 .
                \\3
                \\ok>
                ,
            },
            .{
                .name = "dot underflow error",
                .script = ".\n",
                .expected_stack = &.{},
                .expected_error = "StackUnderflow",
            },
            .{
                .name = "unknown word error",
                .script = "foo\n",
                .expected_error = "UnknownWord",
            },
        },
    };
}
