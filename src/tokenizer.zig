const std = @import("std");

pub const Tokenizer = struct {
    pub fn iterator(_: Tokenizer, line: []const u8) TokenIterator {
        return TokenIterator{
            .buffer = line,
            .index = 0,
        };
    }
};

pub const TokenIterator = struct {
    buffer: []const u8,
    index: usize,

    pub fn next(self: *TokenIterator) ?[]const u8 {
        _ = self;
        // Lesson 1: implement whitespace tokenization here.
        return null;
    }
};
