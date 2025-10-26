const harness = @import("lesson_harness");

// Lesson 1 — REPL + Tokenizer + VM Skeleton
// Why:
// - A Forth is an interactive interpreter, so we need the REPL loop early.
// - Tokenizing input on whitespace lets us observe how words will be parsed.
// - A VM skeleton with push/pop primes the stack discipline used everywhere else.
//
// What to Build:
// - Print an `ok>` prompt REPL that persists line to line.
// - Tokenize input on whitespace and echo the tokens (debug behavior).
// - Provide a VM container with stack push/pop helpers.
//
// Tests (behavior expectations):
// - Tokenizing `2 3 +` prints the three tokens individually.
// - Extra whitespace like `  10   20` produces only the meaningful tokens.
// - The REPL continuously prints `ok>` for every new line of input.

pub fn lesson() harness.Lesson {
    return .{
        .number = 1,
        .title = "REPL + Tokenizer + VM Skeleton",
        .cases = &.{
            .{
                .name = "tokenizing basic input",
                .token_input = "2 3 +",
                .expected_tokens = &.{ "2", "3", "+" },
            },
            .{
                .name = "tokenizer skips whitespace",
                .token_input = "  10   20",
                .expected_tokens = &.{ "10", "20" },
            },
            .{
                .name = "prompt repeats",
                .script = "2 3 +\n1 2\n",
                .expected_stdout =
                \\ok> 2 3 +
                \\ok> 1 2
                \\ok>
                ,
            },
        },
    };
}
