% checks if the current location (I, J) is in the board
locationValid(I, J) :-
    chessboard(Rows, Columns),
    I >= 0,
    I < Rows,
    J >= 0,
    J < Columns.

% tracks all the possible moves the knight can make at location (I, J)
possibleMoves(I, J, NextI, NextJ) :-
    position(I, J),
    ((NextI is I+1, NextJ is J+2);
    (NextI is I+1, NextJ is J-2);
    (NextI is I-1, NextJ is J-2);
    (NextI is I-1, NextJ is J+2);
    (NextI is I+2, NextJ is J+1);
    (NextI is I+2, NextJ is J-1);
    (NextI is I-2, NextJ is J-1);
    (NextI is I-2, NextJ is J+1)).

% creates a list of size S, all zeros
createEmptyList(0, []) :- !.
createEmptyList(S, [H|T]) :-
    H is 0,
    NewS is S-1,
    createEmptyList(NewS, T).

% creates a list that can track how many moves available at each spot in chessboard (so Warnsdorff's heuristic can be used)

% displays final output of tour

% converts 2-D position in chessboard to list index
convertToListIndex(I, J, N, ListIndex) :-
    chessboard(N, _),
    position(I, J),
    ListIndex is (N*I) + J.

% converts list index to position in chessboard
convertToBoardPosition(Index, N, M, I, J) :-
    chessboard(N, M),
    I is Index//M,
    J is Index - (I*N).

setup :-
    write('Enter the number of rows in chessboard: '),
    read(Rows),
    write('Enter the number of columns in chessboard: '),
    read(Columns),
    write('What would you like the row position of the knight to be?'),
    read(X),
    write('What would you like the column position of the knight to be?'),
    read(Y),
    ChessBoard =.. [chessboard, Rows, Columns],
    Position =.. [position, X, Y],
    assert(ChessBoard),
    assert(Position).

%     % writeln(Rows),
%     % writeln(Columns),
%     % writeln(X),
%     % writeln(Y).
% N, M, I, J are just filler variable names for the rules, the actual values are Rows, Columns, X, and Y