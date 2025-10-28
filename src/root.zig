// Library surface exported to consumers; re-exports the interpreter and helpers.
// As lessons advance, more files will be re-exported here (e.g. word registries,
// script loaders) so the rest of the codebase can import `zorth` as a single hub.
const interpreter_mod = @import("interpreter.zig");

pub const Cell = interpreter_mod.Cell;
pub const Interpreter = interpreter_mod.Interpreter;
pub const InterpreterError = interpreter_mod.InterpreterError;

pub const tokenizer = @import("tokenizer.zig");
pub const vm = @import("vm.zig");
pub const words = @import("words.zig");
pub const Repl = @import("repl.zig").Repl;
