const std = @import("std");

pub const Terminal = struct {
    stdout: *std.Io.Writer,
    stdin: *std.Io.Reader,
    pub fn print(self: Terminal, comptime text: []const u8, args: anytype) !void {
        try self.stdout.print(text, args);
        try self.stdout.flush();
    }

    pub fn read(self: Terminal) !?[]const u8 {
        const input_line = (try self.stdin.takeDelimiter('\n')) orelse return null;

        if (input_line.len > 0 and input_line[input_line.len - 1] == '\r') {
            return input_line[0 .. input_line.len - 1];
        }

        return input_line;
    }
};
