% ex:
% sentence_type(["hello","bot"],T).
% T unifies with "greetings".
sentence_type(L,T) :-
    type(T,L,_).

type(T) -->  usefulword(T),! ; [_],type(T),!.

usefulword("greetings") --> ["hello"]; ["hi"].
usefulword("offerhelp") --> ["help"]; ["need"].
usefulword("offerexample") --> ["example"]; ["ex"].


% ex:
% sentence_type("greetings","greetings",C).
% C unifies with 0.9.
semtrans(A,B,C):-
    flow(Xs),
    member((A,B,C),Xs).

flow([
	    ("offerhelp","greetings",1),
	    ("greetings","greetings",1),
	    (["b","c"],"a",2)
    ]).





take(_,[],[]).
take(0,_,[]).
take(N,[X|Xs],[X|Ys]):-
    M is N-1,
    take(M,Xs,Ys).
