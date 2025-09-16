const std = @import("std");

const State = struct { turn: u8, board: [9]u8 };
pub fn main() !void {
    const state = State{
        .turn = 1,
        .board = .{ '_', '_', '_', '_', '_', '_', '_', '_', '_' },
    };

    try print_board(state);
}

pub fn print_board(state: State) !void {
    var out_buffer: [1024]u8 = undefined;

    var stdout_writer = std.fs.File.stdout().writer(&out_buffer);

    var stdout_interface = &stdout_writer.interface;

    try stdout_interface.print("| {c} | {c} | {c} | \n", .{ state.board[0], state.board[1], state.board[2] });
    try stdout_interface.print("| {c} | {c} | {c} | \n", .{ state.board[3], state.board[4], state.board[5] });
    try stdout_interface.print("| {c} | {c} | {c} | \n", .{ state.board[6], state.board[7], state.board[8] });

    try stdout_interface.flush();
}
