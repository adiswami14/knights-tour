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

% checks the number of possible moves from (I, J) and puts the value into Val
checkPossibleMoves(I, J, L, Val, NextI, NextJ) :-
    chessboard(Rows, Columns),
    setof([NextI, NextJ], hasMovePossible(I, J, L, NextI, NextJ), PossibleMoves),
    % getLength(PossibleMoves, Val), % Val is length of PossibleMoves
    % write(PossibleMoves).
    length(PossibleMoves, Val),
    writeln(Val).

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
    % setof((Val, [NewI, NewJ]), checkPossibleMoves(NewI, NewJ, L, Val, NewI, NewJ), NextMoves),
    checkPossibleMoves(I, J, L, Val, NewI, NewJ).
    % setof(Locations, setof([NewI, NewJ], hasMovePossible(I, J, L, NewI, NewJ), Locations), NextMoves).
    % writeln(NextMoves).
    % (NewI, NewJ) = Locations.

% Get length of a set
getLength([], 0).
getLength([H|T], Length) :- 
    getLength(T, L),
    L is Length+1.

% displays final output of tour
displayTour([]) :- !.
displayTour([H|T]) :-
    writeln(H),
    displayTour(T).

% Counting number of possible moves from location (I, J)
hasMovePossible(I, J, L, NextI, NextJ) :-
    possibleMoves(I, J, NextI, NextJ),
    notBeenVisited(NextI, NextJ, L).

% checks if square (I, J) has not been visited
notBeenVisited(I, J, L) :-
    locationValid(I, J),
    \+ member([[I, J]], L).
    % convertToListIndex(I, J, Rows, Columns, Index),
    % nth0(Index, L, Val),
    % Val =:= [0, 0].  % Looking if value at the index hasn't been touched yet

% converts 2-D position in chessboard to list index
convertToListIndex(I, J, N, M, ListIndex) :-
    ListIndex is (M*I) + J.

% converts list index to position in chessboard
convertToBoardPosition(Index, N, M, I, J) :-
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
    createTour(AppendedTour, 1, 1, TotalMoves).
    % displayTour(AppendedTour).

createTour(L, _, _, 0) :- !.
    % displayTour(L).
createTour(Tour, I, J, TotalMoves) :-
    makeOptimalMove(1, 1, Tour, NewI, NewJ),
    append(Tour, [[NewI, NewJ]], AppendedTour),
    MoveCount is TotalMoves-1,
    createTour(AppendedTour, NewI, NewJ, MoveCount).