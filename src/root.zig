//! puffinDB library root. Re-export public API from here.

//terminal
pub const Terminal = @import("terminal.zig").Terminal;

//statement
pub const Statement = @import("statement.zig").Statement;
pub const dotMetaCommand = @import("statement.zig").dotMetaCommand;
pub const prepareStatement = @import("statement.zig").prepareStatement;
pub const executeStatement = @import("statement.zig").executeStatement;
