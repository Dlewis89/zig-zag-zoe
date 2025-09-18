const std = @import("std");

const State = struct { turn: u8, board: [9]u8, game_over: bool };
pub fn main() !void {
    var state = State{ .turn = 1, .board = .{ '_', '_', '_', '_', '_', '_', '_', '_', '_' }, .game_over = false };

    var in_buffer: [1024]u8 = undefined;
    var stdin = std.fs.File.stdin().reader(&in_buffer);
    var stdin_interface = &stdin.interface;

    while (!state.game_over) {
        try print_board(state);

        const input = try stdin_interface.takeDelimiterExclusive('\n');

        if (std.mem.eql(u8, input, "q")) {
            state.game_over = true;
            break;
        }

        const pos = std.fmt.parseInt(u8, input, 10) catch {
            std.debug.print("Failed to parse input, please you a number between 0 and 8", .{});
            continue;
        };

        player_input(&state, pos);

        state.turn += 1;
    }
}

fn print_board(state: State) !void {
    var out_buffer: [1024]u8 = undefined;

    var stdout_writer = std.fs.File.stdout().writer(&out_buffer);

    var stdout_interface = &stdout_writer.interface;

    try stdout_interface.print("| {c} | {c} | {c} | \n", .{ state.board[0], state.board[1], state.board[2] });
    try stdout_interface.print("| {c} | {c} | {c} | \n", .{ state.board[3], state.board[4], state.board[5] });
    try stdout_interface.print("| {c} | {c} | {c} | \n", .{ state.board[6], state.board[7], state.board[8] });

    try stdout_interface.flush();
}

fn player_input(state: *State, position: u8) void {
    const player = state.turn % 2;

    switch (player) {
        1 => {
            state.board[position] = 'X';
        },
        0 => {
            state.board[position] = 'O';
        },
        else => {
            std.debug.print("Something went wrong with adding player symbol to board position!", .{});
        },
    }
}
