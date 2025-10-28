// Spec cases for Lesson 4; documents user-defined word compilation.
// As future lessons add control flow or memory words, complement them with
// scenarios here to demonstrate how user code composes the new primitives.
const harness = @import("lesson_harness");

// Lesson 4 — User-Defined Words (`: name ... ;`)
// Why:
// - Forth becomes self-hosting when users can define words inside the language itself.
// - Compile mode toggling introduces the workflow for extending the dictionary at runtime.
// - Proper error handling (e.g., missing `;`) prevents broken compile sessions from poisoning state.
//
// What to Build:
// - Enter compile mode when `:` is seen, treating the next token as the word name.
// - Collect actions until `;`, then store the new definition in the dictionary.
// - Execute user-defined words just like built-ins after compilation finishes.
//
// Tests (behavior expectations):
// - `: SQR DUP * ; 4 SQR .` prints `16`.
// - `: TWICE DUP + ; 7 TWICE .` prints `14`.
// - Nested definitions like `: POW4 SQR SQR ; 2 POW4 .` work correctly.
// - Missing `;` (e.g., `: X 2`) yields a graceful error and resets compile state.

pub fn lesson() harness.Lesson {
    return .{
        .number = 4,
        .title = "User-Defined Words",
        .cases = &.{
            .{
                .name = "square word",
                .script = ": SQR DUP * ; 4 SQR .\n",
                .expected_stack = &.{},
                .expected_stdout =
                \\ok> : SQR DUP * ; 4 SQR .
                \\16
                \\ok>
                ,
            },
            .{
                .name = "twice word",
                .script = ": TWICE DUP + ; 7 TWICE .\n",
                .expected_stack = &.{},
                .expected_stdout =
                \\ok> : TWICE DUP + ; 7 TWICE .
                \\14
                \\ok>
                ,
            },
            .{
                .name = "nested word",
                .script = ": SQR DUP * ; : POW4 SQR SQR ; 2 POW4 .\n",
                .expected_stack = &.{},
                .expected_stdout =
                \\ok> : SQR DUP * ; : POW4 SQR SQR ; 2 POW4 .
                \\16
                \\ok>
                ,
            },
            .{
                .name = "missing semicolon reset",
                .script = ": X 2\n",
                .expected_error = "CompileMode",
            },
        },
    };
}
