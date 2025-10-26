const harness = @import("lesson_harness");

// Lesson 3.5 — Core Stack Words (DUP, DROP, SWAP, OVER, .S)
// Why:
// - Forth moves data exclusively via the stack, so these primitives are foundational.
// - Most later words are built on these stack shuffles.
// - `.S` gives immediate debugging visibility into the current stack.
// Reinforces thinking in stack effects, safe underflow handling, and readable diagnostics.
//
// What to Build:
// - `DUP`  (a -- a a)
// - `DROP` (a -- )
// - `SWAP` (a b -- b a)
// - `OVER` (a b -- a b a)
// - `.S` prints `<depth> item...` without mutating the stack.
// All words must protect against underflow and leave the stack unchanged on failure.
//
// Tests:
// - Basic transformations confirm stack effects and `.S` output.
// - Underflow scenarios ensure errors are reported and the stack stays intact.
// - `.S` accurately reports depth for empty and populated stacks.

pub fn lesson() harness.Lesson {
    return .{
        .number = 35,
        .title = "Core Stack Words",
        .cases = &.{
            .{
                .name = "duplication shows in stack and output",
                .script = "5 DUP .S\n",
                .expected_stdout =
                \\ok> 5 DUP .S
                \\<2> 5 5
                \\ok>
                ,
                .expected_stack = &.{ 5, 5 },
            },
            .{
                .name = "drop removes the single item",
                .script = "7 DROP .S\n",
                .expected_stdout =
                \\ok> 7 DROP .S
                \\<0>
                \\ok>
                ,
                .expected_stack = &.{},
            },
            .{
                .name = "swap exchanges top two values",
                .script = "2 3 SWAP .S\n",
                .expected_stdout =
                \\ok> 2 3 SWAP .S
                \\<2> 3 2
                \\ok>
                ,
                .expected_stack = &.{ 3, 2 },
            },
            .{
                .name = "over copies the second item",
                .script = "1 2 OVER .S\n",
                .expected_stdout =
                \\ok> 1 2 OVER .S
                \\<3> 1 2 1
                \\ok>
                ,
                .expected_stack = &.{ 1, 2, 1 },
            },
            .{
                .name = "drop underflow leaves stack untouched",
                .script = "DROP\n",
                .expected_stack = &.{},
                .expected_error = "StackUnderflow",
            },
            .{
                .name = "swap underflow with single item",
                .script = "1 SWAP\n",
                .expected_stack = &.{ 1 },
                .expected_error = "StackUnderflow",
            },
            .{
                .name = "over underflow with single item",
                .script = "1 OVER\n",
                .expected_stack = &.{ 1 },
                .expected_error = "StackUnderflow",
            },
            .{
                .name = "dup underflow on empty stack",
                .script = "DUP\n",
                .expected_stack = &.{},
                .expected_error = "StackUnderflow",
            },
            .{
                .name = ".S empty stack shows zero depth",
                .script = ".S\n",
                .expected_stdout =
                \\ok> .S
                \\<0>
                \\ok>
                ,
                .expected_stack = &.{},
            },
            .{
                .name = ".S after pushes reports depth and values",
                .script = "3 4 .S\n",
                .expected_stdout =
                \\ok> 3 4 .S
                \\<2> 3 4
                \\ok>
                ,
                .expected_stack = &.{ 3, 4 },
            },
        },
    };
}
