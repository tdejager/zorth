# Zorth — A Modern Educational Forth in Zig

## Overview

Zorth is a small, modern, **direct-threaded** Forth implementation written in Zig.
It is designed as a **learning tool** for exploring:

- Stack-based language semantics
- Parsing and interpreters
- Memory and error management in Zig
- Extensible language design

The project is developed incrementally, each step building on the last — with **clear motivations** and **tests**.

---

## Compatibility & Intent

Zorth is closest to **ANS Forth (1994)** — specifically the **Core** + **Core Extensions** word sets — while:

✅ Adopting a modern memory model (64-bit cells)  
✅ Using explicit error handling (not silent undefined behavior)  
✅ Favoring readability for learning over minimalism

Not included initially (may be added later):

- Floating point words
- File I/O beyond including scripts
- Return stack control flow (until later lessons)
- System-specific quirks from older Forths

Execution Model: **Direct-threaded** (lists of function pointers)  
Token parsing: Whitespace-separated (traditional)  
Numbers: Integers only initially (`i64`)

The long-term goal is to be a **useful, hackable minimal Forth** aligned with Forth-2012 concepts.

---

## Project Layout

```
src/
main.zig // REPL: tokenize, dispatch to VM
vm.zig // VM struct: stack, dictionary, modes
words.zig // Built-in words (arithmetic, stack ops)
```

---


This may expand as features grow (e.g., control flow, memory ops).

---

## Running the Lesson Harness

- `zig build test` — baseline compilation/tests; does **not** run lesson specs.
- `zig build lessons -Dlesson=N` — runs the scripted specs for lesson `N` (1–4, 35).  
  Example: `zig build lessons -Dlesson=1` to focus on the tokenizer/REPL expectations.
- Each lesson case is defined under `tests/lessons/lessonN.zig`.  
  Update or extend these when you add new behaviors.

The harness drives `src/testing/lesson_harness.zig`, which feeds scripts through the `Interpreter`
and compares the observed stack/output/errors to each lesson’s table.

---

# ✅ Lesson Plan

Each lesson includes:
- **Why** (motivation)
- **What** (required capabilities)
- **Tests** (behavior expectations)

---

## Lesson 1 — REPL + Tokenizer + VM Skeleton

### Why
A Forth *is* an interactive interpreter.  
We need:
- Input loop
- Tokenization
- A VM container for execution state

### What to Build
- `ok>` prompt REPL
- Tokenize input on whitespace
- Echo tokens (debug behavior)
- VM with stack (`push` / `pop`)

### Tests

| Behavior | Input | Expected |
|---------|-------|----------|
| Tokenizing | `2 3 +` | Prints tokens: `2`, `3`, `+` |
| Skips empty tokens | `  10   20` | Only `10` and `20` |
| Persistent REPL | Multiple lines | Always prints `ok>` |

✅ Passing means Lesson 1 complete.

---

## Lesson 2 — Integer Handling + Print (`.`)

### Why
Forth’s fundamental data exchange happens through the **data stack**.

This introduces:
- Parsing values from input
- Safe error handling
- Displaying stack results

### What to Build
- Parse integer → push to stack
- `.` pops and prints
- Unknown words → clear error message
- Underflow detection

### Tests

| Input | Stack Result | Output |
|-------|--------------|--------|
| `2` | `[2]` |  |
| `2 3` | `[2, 3]` | |
| `.` after `3` | `[2]` | `3` |
| `.` on empty | `[]` | Error: stack underflow |
| `foo` | Unchanged | `Unknown word: foo` |

✅ Passing means Lesson 2 complete.

---

## Lesson 3 — Dictionary + Arithmetic (`+ - * /`)

### Why
Forth is extensible by design — words are runtime bindings of names to behaviors.

This enables:
- Symbol lookup
- Built-in operations
- Real execution

### What to Build
- Word struct: `{ name, action }`
- Dictionary stored in VM
- Built-ins: `+ - * /`
- Execution dispatch order:
  1. Lookup word by name
  2. Else try integer parse
  3. Else error

### Tests

| Input | Output | Final Stack |
|-------|--------|-------------|
| `2 3 + .` | `5` | `[]` |
| `5 1 - .` | `4` | `[]` |
| Underflow | `+` | Error | `[]` |

✅ Passing means Lesson 3 complete.

---

## Lesson 3.5 — Core Stack Words (`DUP`, `DROP`, `SWAP`, `OVER`, `.S`)

### Why
These are the **fundamental mechanics** of programming in Forth:

- Data moves only through the stack
- Higher-level words build on these primitives
- `.S` provides a debugging view of the current stack

This lesson emphasizes:
- Thinking in **stack effects**
- Underflow safety
- Printing for development insights

### What to Build

| Word | Stack Effect | Meaning |
|------|--------------|---------|
| `DUP` | ( a -- a a ) | Duplicate top |
| `DROP` | ( a -- ) | Remove top |
| `SWAP` | ( a b -- b a ) | Exchange top two |
| `OVER` | ( a b -- a b a ) | Copy second item to top |
| `.S` | ( ... -- ... ) | Print entire stack without mutating it |

**Notes**
- All words must guard against underflow and leave the stack unchanged on failure
- `.S` format suggestion: `<depth> item1 item2 ... itemN`
  - Example: stack `2 10 42` ⇒ `.S` prints `<3> 2 10 42`

### Tests

**Basic transformations**

| Input | Expected Output | Final Stack |
|-------|-----------------|-------------|
| `5 DUP .S` | `<2> 5 5` | `[5, 5]` |
| `7 DROP .S` | `<0>` | `[]` |
| `2 3 SWAP .S` | `<2> 3 2` | `[3, 2]` |
| `1 2 OVER .S` | `<3> 1 2 1` | `[1, 2, 1]` |

**Underflow safety**

| Word | Expected |
|------|----------|
| `DROP` with empty stack | Error printed, stack unchanged |
| `SWAP` with only one element | Error printed, stack unchanged |
| `OVER` with only one element | Error printed, stack unchanged |
| `DUP` on empty stack | Error printed, stack unchanged |

**`.S` correctness**

| Scenario | Expected `.S` |
|----------|---------------|
| Empty stack | `<0>` |
| After `3 4` | `<2> 3 4` |

✅ Passing means Lesson 3.5 complete.

---

## Lesson 4 — User-Defined Words (`: name ... ;`)

### Why
This is when the language becomes *self-hosting*:
Users define new words inside the language itself.

### What to Build
- Compile mode begins at `:`
- Next token is the word name
- Append actions until `;`
- Then store new word in dictionary
- Execute it like a built-in

### Tests

| Definition | Invocation | Expected |
|-----------|------------|----------|
| `: SQR DUP * ;` | `4 SQR .` | `16` |
| `: TWICE DUP + ;` | `7 TWICE .` | `14` |
| Nested | `: POW4 SQR SQR ; 2 POW4 .` | `16` |
| Missing `;` | `: X 2` → run | Graceful error + reset |

✅ Passing means Lesson 4 complete.

---

### Lessons 5+ (to be expanded)

Planned topics:
- Memory model (`CREATE`, `ALLOT`, `@`, `!`)
- Control flow (`IF`, `ELSE`, `THEN`, `BEGIN`, `UNTIL`)
- Include files (`INCLUDE`)
- Standard library bootstrap
- Performance / direct threading optimizations
- Optional: Bytecode interpreter backend

---

## Status Checklist ✅

- [ ] Lesson 1 complete (REPL + VM + tokenizing)
- [ ] Lesson 2 complete (integer + print)
- [ ] Lesson 3 complete (dictionary + math)
- [ ] Lesson 3.5 complete (core stack words)
- [ ] Lesson 4 complete (user-defined words)
- [ ] Lesson 5+ milestones

(You can extend this with GitHub Issues / PRs)

---

## Banner Example
