const std = @import("std");

const State = struct { turn: u8, board: [9]u8, game_over: bool, winner: u8 };
pub fn main() !void {
    var state = State{ .turn = 1, .board = .{ '_', '_', '_', '_', '_', '_', '_', '_', '_' }, .game_over = false, .winner = '_' };

    var in_buffer: [1024]u8 = undefined;
    var stdin = std.fs.File.stdin().reader(&in_buffer);
    var stdin_interface = &stdin.interface;

    while (!state.game_over) {
        try print_board(state);

        checkForHorizontallWins(&state);
        checkForVerticalWins(&state);
        checkForDiagonalWins(&state);

        if (state.game_over) {
            break;
        }

        const input = try stdin_interface.takeDelimiterExclusive('\n');

        if (std.mem.eql(u8, input, "q")) {
            state.game_over = true;
            break;
        }

        const pos = std.fmt.parseInt(u8, input, 10) catch {
            std.log.err("Failed to parse input, please you a number between 0 and 8", .{});
            continue;
        };

        player_input(&state, pos);

        state.turn += 1;
    }

    std.debug.print("Winner is {c}\n", .{state.winner});
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

fn checkForHorizontallWins(state: *State) void {
    if (state.board[0] == state.board[1] and state.board[0] == state.board[2] and state.board[0] != '_') {
        state.winner = state.board[0];
        state.game_over = true;
        return;
    }

    if (state.board[3] == state.board[4] and state.board[3] == state.board[5] and state.board[3] != '_') {
        state.winner = state.board[3];
        state.game_over = true;
        return;
    }

    if (state.board[6] == state.board[7] and state.board[6] == state.board[8] and state.board[6] != '_') {
        state.winner = state.board[6];
        state.game_over = true;
        return;
    }
}

fn checkForVerticalWins(state: *State) void {
    if (state.board[0] == state.board[3] and state.board[0] == state.board[6] and state.board[0] != '_') {
        state.winner = state.board[0];
        state.game_over = true;
        return;
    }

    if (state.board[1] == state.board[4] and state.board[1] == state.board[7] and state.board[1] != '_') {
        state.winner = state.board[1];
        state.game_over = true;
        return;
    }

    if (state.board[2] == state.board[5] and state.board[2] == state.board[6] and state.board[2] != '_') {
        state.winner = state.board[2];
        state.game_over = true;
        return;
    }
}

fn checkForDiagonalWins(state: *State) void {
    if (state.board[0] == state.board[4] and state.board[0] == state.board[7] and state.board[0] != '_') {
        state.winner = state.board[0];
        state.game_over = true;
        return;
    }

    if (state.board[2] == state.board[4] and state.board[2] == state.board[6] and state.board[2] != '_') {
        state.winner = state.board[3];
        state.game_over = true;
        return;
    }
}
