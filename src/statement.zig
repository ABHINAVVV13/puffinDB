const std = @import("std");
const term = @import("terminal.zig").Terminal;

pub const MetaCommandResult = enum {
    success,
    unrecognized_command,
};

pub const PrepareResult = enum {
    success,
    unrecognized_statement,
};

pub const StatementType = enum {
    insert,
    select,
};

pub const Statement = struct { type: StatementType };

pub fn dotMetaCommand(command: []const u8) MetaCommandResult {
    if (std.mem.eql(u8, command, ".exit")) {
        std.process.exit(0);
    }
    return .unrecognized_command;
}

pub fn prepareStatement(command: []const u8, statement: *Statement) PrepareResult {
    if (std.mem.startsWith(u8, command, "insert")) {
        statement.* = .{ .type = .insert };
        return .success;
    }

    if (std.mem.eql(u8, command, "select")) {
        statement.* = .{ .type = .select };
        return .success;
    }

    return .unrecognized_statement;
}

pub fn executeStatement(statement: Statement, terminal: term) !void {
    switch (statement.type) {
        .insert => try terminal.print("This is where we would do an insert.\n", .{}),
        .select => try terminal.print("This is where we would do a select.\n", .{}),
    }
}
