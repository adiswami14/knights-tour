% checks if the current location (I, J) is in the board
locationValid(I, J) :-
    chessboard(Rows, Columns),
    I >= 0,
    I < Rows,
    J >= 0,
    J < Columns.

% tracks all the possible moves the knight can make at location (I, J)
possibleMoves(I, J, NextI, NextJ) :-
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

% changes list val at index I to value
changeListVal([H|T], 0, Value) :-
    H is Value.
changeListVal([H|T], Index, Value) :-
    Ind is Index-1,
    changeListVal(T, Ind, Value).

% updates the list that can track how many moves available at spot (I, J) in chessboard (so Warnsdorff's heuristic can be used)

% checks the number of possible moves from (I, J) is Val
checkPossibleMoves(I, J, L, Val) :-
    chessboard(Rows, Columns),
    setof(_, hasMovePossible(I, J, L), PossibleMoves), 
    length(PossibleMoves, Val).
    % convertToListIndex(I, J, Rows, Columns, Index),
    % changeListVal(L, Index, NumPossibleMoves).

makeMove() :- !.

% displays final output of tour

% Counting number of possible moves from location (I, J)
hasMovePossible(I, J, L) :-
    possibleMoves(I, J, NextI, NextJ),
    notBeenVisited(NextI, NextJ, L).

% checks if square (I, J) has not been visited
notBeenVisited(I, J, L) :-
    chessboard(Rows, Columns),
    locationValid(I, J),
    convertToListIndex(I, J, Rows, Columns, Index),
    nth0(Index, L, Val),
    Val =:= 0.  % Looking if value at the index hasn't been touched yet

% converts 2-D position in chessboard to list index
convertToListIndex(I, J, N, M, ListIndex) :-
    chessboard(N, M),
    ListIndex is (M*I) + J.

% converts list index to position in chessboard
convertToBoardPosition(Index, N, M, I, J) :-
    chessboard(N, M),
    I is Index//M,
    J is Index - (I*M).

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