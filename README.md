# Zorth, learning zig

This is my attempt to learn the Zig programming language by creating a simple command line tool called Zorth.
Zorth is a minimalistic Forth-like interpreter implemented in Zig.
I've had the lessons built up by Codex, including some minimal scaffolding.

```mermaid
flowchart TD
    A[main.zig\nCLI entry point] --> B[repl.zig\nREPL loop]
    B --> C[interpreter.zig\nTokenize + dispatch]
    C --> D[tokenizer.zig\nWhitespace splitter]
    C --> E[vm.zig\nData stack]
    C --> F[words.zig\nDictionary]
    F --> G[src/testing/lesson_harness.zig\nLesson driver]
```
