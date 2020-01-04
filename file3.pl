nats(0,[]).
nats(N,[N|Xs]) :-
    X is N-1, nats(X,Xs).

draw(N,R) :-
    nats(N,A), random_permutation(A,B),!, member(R,B).

sentence_type(L,T):-
    type(T,L,[]).

type("askhelp") --> {draw(2,R)}, askhelp(R).

askhelp(1) --> {draw(2,R)}, question(R), ["help"], other.
askhelp(2) --> ["I"], ["need"], ["help"].
question(1) --> {draw(2,R)}, cap, you(R).
question(2) --> {draw(2,R)}, you(R), cap.
cap --> ["can"].
you(1) --> ["you"].
you(2) --> ["the"], ["chatbot"].
other --> ["me?"].


