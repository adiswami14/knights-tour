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