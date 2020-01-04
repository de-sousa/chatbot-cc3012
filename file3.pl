nats(0,[]).
nats(N,[N|Xs]) :-
    not(compare(<,N,1)),
    X is N-1,
    nats(X,Xs).

draw(N,R) :-
    nats(N,A), random_permutation(A,B),!, member(R,B).

take(0,_,[]).
take(_,[],[]).
take(N,[X|Xs],[X|Ys]) :-
    M is N-1,
    take(M,Xs,Ys).

%---------------------------

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

type("greetings") --> {draw(2,R)}, greetings(R).
greetings(1) --> {draw(2,R)}, hi(R).
greetings(2) --> {draw(2,R)}, hi(R), to.
hi(1) --> ["hi"].
hi(2) --> ["hello"].
to --> {draw(3,R)}, to(R).
to(1) --> ["chatbot"].
to(2) --> ["dear"], ["friend"].
to(3) --> ["friend"].

type("goodbye") --> ["bye"].

%---------------------------

sumall(_,[],0).
sumall(A,[(A,_,C)|Flow],Sum):-sumall(A,Flow,S1), Sum is C+S1.
sumall(A,[(B,_,_)|Flow],Sum):-not(A=B),sumall(A,Flow,Sum).

choose(A,[(A,B,C)|_],Ca,R,(B,C)):-
    Ca1 is Ca+C,
    compare(<,R,Ca1).
choose(A,[(A,_,C)|Flow],Ca,R,(D,E)):-
    Ca1 is Ca+C,
    compare(>,R,Ca1),
    choose(A,Flow,Ca1,R,(D,E)).
choose(A,[(B,_,_)|Flow],Ca,R,(C,D)):-
    not(A=B),
    choose(A,Flow,Ca,R,(C,D)).

% ex:
% sentence_type("greetings","greetings",C).
% C unifies with 0.9.
semtrans(A,B,C):-
    flow(Flow),!,
    sumall(A,Flow,Sum),
    not(Sum=0),
    random(0.0,Sum,R),!,
    choose(A,Flow,0,R,(B,C)).

flow([
	    ([],"greetings",1),
	    (["greetings","greetings"],"askhelp",1),
	    (["greetings"],"greetings",1)
    ]).

%---------------------------

select(Ts,T) :-
    nats(3,Ns),
    member(A,Ns),
    take(A,Ts,X),
    semtrans(X,T,_).

%---------------------------

write_fancy([]):-
    write("\n").
write_fancy([X|Xs]):-
    write(" "),
    write(X),
    write_fancy(Xs).

chataway_beta(L) :-
    chat_beta(L,[]). 

chat_beta(0,_) :- sentence_type(A,"goodbye"), write("- "), write_fancy(A),!.
chat_beta(N,Ms) :- select(Ms,T),!, sentence_type(A,T), write("-"), write_fancy(A), M is N-1, chat_beta(M,[T|Ms]).

chataway(L) :-
    chat(L,[],_,[]).

chat(0,_) --> type("goodbye"),!.
chat(N,Ms) --> {M is N-1, select(Ms,T),!}, type(T), chat(M,[T|Ms]).

chat_at_aim(From,To,L,_):-
    chat(L,[],From,To).
