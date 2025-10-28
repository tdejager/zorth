// Spec cases for Lesson 3; focuses on dictionary lookups and arithmetic words.
// When you introduce new builtin categories (logic, memory), mirror them here
// before advancing to later lessons.
const harness = @import("lesson_harness");

// Lesson 3 — Dictionary + Arithmetic (`+ - * /`)
// Why:
// - Forth’s extensibility comes from runtime dictionary lookups, so every token needs resolution.
// - Built-in arithmetic words let us test the execution dispatch path end to end.
// - Establishing lookup order avoids ambiguity: dictionary words, then numeric literals, else error.
//
// What to Build:
// - Word struct containing `{ name, action }` entries stored in the VM dictionary.
// - Built-in arithmetic words: `+`, `-`, `*`, `/`.
// - Dispatch rules: try dictionary lookup, else integer parse, else produce an error.
//
// Tests (behavior expectations):
// - `2 3 + .` prints `5` and leaves an empty stack.
// - `5 1 - .` prints `4` and leaves an empty stack.
// - Running an arithmetic word like `+` without enough stack items triggers underflow.

pub fn lesson() harness.Lesson {
    return .{
        .number = 3,
        .title = "Dictionary + Arithmetic",
        .cases = &.{
            .{
                .name = "addition pipeline",
                .script = "2 3 + .\n",
                .expected_stack = &.{},
                .expected_stdout =
                \\ok> 2 3 + .
                \\5
                \\ok>
                ,
            },
            .{
                .name = "subtraction pipeline",
                .script = "5 1 - .\n",
                .expected_stack = &.{},
                .expected_stdout =
                \\ok> 5 1 - .
                \\4
                \\ok>
                ,
            },
            .{
                .name = "underflow on arithmetic",
                .script = "+\n",
                .expected_stack = &.{},
                .expected_error = "StackUnderflow",
            },
        },
    };
}
