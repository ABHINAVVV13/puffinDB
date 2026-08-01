const std = @import("std");
const puffinDB = @import("puffinDB");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdout_buffer: [1024]u8 = undefined;
    var std_file_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &std_file_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var std_file_reader = std.Io.File.stdin().reader(io, &stdin_buffer);
    const stdin = &std_file_reader.interface;

    const terminal = puffinDB.Terminal{ .stdout = stdout, .stdin = stdin };

    while (true) {
        try terminal.print("db > ", .{});
        const command: []const u8 = (try terminal.read()) orelse break;

        if (command.len > 0 and command[0] == '.') {
            switch (puffinDB.dotMetaCommand(command)) {
                .success => continue,
                .unrecognized_command => {
                    try terminal.print("Unrecognized Command '{s}'\n", .{command});
                    continue;
                },
            }
        }

        var statement: puffinDB.Statement = undefined;

        switch (puffinDB.prepareStatement(command, &statement)) {
            .success => {},
            .unrecognized_statement => {
                try terminal.print("Unrecognized keyword at start of '{s}'.\n", .{command});
                continue;
            },
        }

        try puffinDB.executeStatement(statement, terminal);

        try terminal.print("Executed. \n", .{});
    }
}
