const std = @import("std");

const puffinDB = @import("puffinDB");

fn printTerminal(stdout: *std.Io.Writer, comptime text: []const u8, args: anytype) !void {
    try stdout.print(text, args);
    try stdout.flush();
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdout_buffer: [1024]u8 = undefined;
    var std_file_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &std_file_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var std_file_reader = std.Io.File.stdin().reader(io, &stdin_buffer);
    const stdin = &std_file_reader.interface;

    while (true) {
        try printTerminal(stdout, "db > ", .{});

        const input_line = (try stdin.takeDelimiter('\n')) orelse break;
        var command: []const u8 = "";

        //strip trailing '\r' if present
        if (input_line.len > 0 and input_line[input_line.len - 1] == '\r') {
            command = input_line[0 .. input_line.len - 1];
        } else {
            command = input_line;
        }

        if (std.mem.eql(u8, command, ".exit")) {
            break;
        } else {
            try printTerminal(stdout, "Unrecognized command '{s}'. \n", .{command});
        }
    }
}
