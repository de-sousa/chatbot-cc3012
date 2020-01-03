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
	    (["b","c"],"a",2),
	    ("offerhelp","greetings",1),
	    ("greetings","greetings",2)
    ]).


chataway(0):-
    write("Sorry, but now i have to go, see you later\n"),!.
chataway(L):-
    L0 is L-1,
    output("offerhelp"),
    chataway(L0).

output(T):-
    phrases(T,Ls),
    length(Ls,L),
    random_between(1,L,R),
    nth1(R,Ls,P),
    write(P).

phrases("offerhelp",[
	   "do you need help?\n",
	   "can i help you?\n",
	   "i would like to help you\n",
	   "what do you want?\n"
       ]).

take(_,[],[]).
take(0,_,[]).
take(N,[X|Xs],[X|Ys]):-
    M is N-1,
    take(M,Xs,Ys).
