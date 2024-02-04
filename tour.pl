% checks if the current location (I, J) is in the board
locationValid(I, J) :-
    chessboard(Rows, Columns),
    I >= 0,
    I < Rows,
    J >= 0,
    J < Columns.

% tracks all the possible moves the knight can make at location (I, J)
possibleMoves(I, J, NextI, NextJ) :-
    NextI is I+1, NextJ is J+2;
    NextI is I+1, NextJ is J-2;
    NextI is I-1, NextJ is J-2;
    NextI is I-1, NextJ is J+2;
    NextI is I+2, NextJ is J+1;
    NextI is I+2, NextJ is J-1;
    NextI is I-2, NextJ is J-1;
    NextI is I-2, NextJ is J+1.

% checks the number of possible moves from (I, J) is Val
checkPossibleMoves(I, J, L, Val) :-
    chessboard(Rows, Columns),
    setof(_, hasMovePossible(I, J, L), PossibleMoves),
    getLength(PossibleMoves, Val).  % Val is length of PossibleMoves

% creates a list of size S, all zeros
createEmptyList(0, L) :- !.
createEmptyList(S, [[0, 0]|T]) :-
    NewS is S-1,
    createEmptyList(NewS, T).

% switch to append to list
append([], L, L).
append([H|T], L, [H|R]) :-
    append(T, L, R).

% Make optimal move by picking move with least amount of possible moves
makeOptimalMove(I, J, L, NewI, NewJ) :- 
    setof((Number, Locations), setof(checkPossibleMoves(I, J, L, Val), hasMovePossible(I, J, L), Locations), NextMoves),
    (NewI, NewJ) = Locations.

% Get length of a set
getLength([], Length) :- !.
getLength([H|T], Length) :- 
    L is Length+1,
    getLength(T, L).

% displays final output of tour
displayTour([]) :- !.
displayTour([H|T]) :-
    writeln(H),
    displayTour(T).

% Counting number of possible moves from location (I, J)
hasMovePossible(I, J, L) :-
    possibleMoves(I, J, NextI, NextJ),
    notBeenVisited(NextI, NextJ, L).

% checks if square (I, J) has not been visited
notBeenVisited(I, J, L) :-
    chessboard(Rows, Columns),
    locationValid(I, J),
    \+ member([I, J], L).
    % convertToListIndex(I, J, Rows, Columns, Index),
    % nth0(Index, L, Val),
    % Val =:= [0, 0].  % Looking if value at the index hasn't been touched yet

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

startTour :-
    chessboard(Rows, Columns),
    position(X, Y),
    TotalMoves is (Rows*Columns),
    append(Tour, [[X, Y]], AppendedTour),
    % createTour(AppendedTour, X, Y, 1, TotalMoves),
    displayTour(AppendedTour).

createTour(Tour, I, J, MoveCount, TotalMoves) :-
    MoveCount =< TotalMoves,
    % makeOptimalMove(I, J, Tour, NewI, NewJ),
    append(Tour, [[NewI, NewJ]], AppendedTour),
    MoveIncrement is MoveCount+1,
    createTour(AppendedTour, NewI, NewJ, MoveIncrement, TotalMoves).