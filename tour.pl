% checks if the current location (I, J) is in the board
locationValid(I, J) :-
    chessboard(Size),
    I >= 0,
    I < Size,
    J >= 0,
    J < Size.

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
checkPossibleMoves(I, J, L, Val) :-
    getPossibleMoves(I, J, L, PossibleMoves, NextI, NextJ),
    % getLength(PossibleMoves, Val), % Val is length of PossibleMoves
    % write(PossibleMoves).
    length(PossibleMoves, Val).

% get all the possible moves from (I, J)
getPossibleMoves(I, J, L, Moves, NextI, NextJ) :-
    setof([NextI, NextJ], hasMovePossible(I, J, L, NextI, NextJ), Moves).

% switch to append to list
append([], L, L).
append([H|T], L, [H|R]) :-
    append(T, L, R).

% Make a brute force move into remaining empty square
makeBruteForceMove(I, J, L, NewI, NewJ) :-
    getPossibleMoves(I, J, L, Moves, NextI, NextJ),
    nth0(0, Moves, [NewI, NewJ]).

% Make optimal move by picking move with least amount of possible moves
makeOptimalMove(I, J, L, NewI, NewJ) :- 
    getPossibleMoves(I, J, L, Moves, NextI, NextJ),
    getOptimalMove(Moves, MoveList, L, SortedMoves),
    nth0(0, SortedMoves, (_, [NewI, NewJ])).

getOptimalMove([], AppendedMoves, _, SortedMoves) :-
    sort(AppendedMoves, SortedMoves).
getOptimalMove([[I, J]|T], MoveList, L, SortedMoves) :-
    checkPossibleMoves(I, J, L, Val),
    append(MoveList, [(Val, [I, J])], AppendedMoves),
    getOptimalMove(T, AppendedMoves, L, SortedMoves).

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
    \+ member([I, J], L).

setup :-
    write('Enter the size of chessboard: '),
    read(Size),
    write('What would you like the row position of the knight to be?'),
    read(X),
    write('What would you like the column position of the knight to be?'),
    read(Y),
    ChessBoard =.. [chessboard, Size],
    Position =.. [position, X, Y],
    assert(ChessBoard),
    assert(Position).

startTour :-
    chessboard(Size),
    position(X, Y),
    TotalMoves is (Size*Size) - 1,
    append(Tour, [[X, Y]], AppendedTour),
    createTour(AppendedTour, 0, 0, TotalMoves).
    % displayTour(AppendedTour).
    
createTour(Tour, I, J, 1) :- % Last move
    makeBruteForceMove(I, J, Tour, NewI, NewJ),
    append(Tour, [[NewI, NewJ]], AppendedTour),
    displayTour(AppendedTour).
createTour(Tour, I, J, TotalMoves) :-
    makeOptimalMove(I, J, Tour, NewI, NewJ),
    append(Tour, [[NewI, NewJ]], AppendedTour),
    MoveCount is TotalMoves-1,
    createTour(AppendedTour, NewI, NewJ, MoveCount).