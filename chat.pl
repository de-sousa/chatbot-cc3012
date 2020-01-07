nats_down(0,[]).
nats_down(N,[N|Xs]) :-
    not(compare(<,N,1)),
    X is N-1,
    nats_down(X,Xs).

nats_up(N,Xs):-
    nats_down(N,Ys),
    reverse(Ys,Xs).

reverse([],[]).
reverse([X|Xs],Ys):-
    reverse(Xs,Zs),
    append(Zs,[X],Ys).

draw(N,R) :-
    nats_down(N,A), random_permutation(A,B),!, member(R,B).

% take(N,L1,L2)
% take takes the N first elements from list L1 and gives them in L2, in the same order
take(0,_,[]).
take(_,[],[]).
take(N,[X|Xs],[X|Ys]) :-
    M is N-1,
    take(M,Xs,Ys).

% write(Xs)
% write outputs a list of words
write_fss([]).
write_fss([X|Xs]):-
    write_fs(X),
    write_fss(Xs).
write_fs(A):-
    write("-"), write_f(A).
write_f([]):-
    write("\n").
write_f([X|Xs]):-
    write(" "),
    write(X),
    write_f(Xs).

group([],[]).
group(As,[Xs|Bs]):-
    append(Xs,Ys,As),
    sentence_type(Xs,_),
    group(Ys,Bs).

output(A):-
    group(A,B),
    write_fss(B).

% list_n(A,N,As):
% As é a lista que contém A N vezes
% ex: 
% :- list_n(a,3,As).
% As = [a, a, a] .
list_n(_,0,[]).
list_n(A,N,[A|As]):-
    M is N-1,
    list_n(A,M,As).

% list_ns(A,Flow,As)
% As é a lista de todas as possibilidades para que A pode ir na conversa, presentes de acordo com a sua probabilidade de ser escolhido
list_ns(_,[],[]).
list_ns(A,[(A,B,C)|Flow],Cs):-
    list_n((B,C),C,As),
    append(As,Bs,Cs),
    list_ns(A,Flow,Bs).
list_ns(A,[(B,_,_)|Flow],Cs):-
    not(A=B),
    list_ns(A,Flow,Cs).


search(_,_,0,_):- fail.
search(From,To,_,[From]):-
    flow(F),
    member(([From],To,_),F).
search(From,To,_,[From]):-
    flow(F),
    member(([From|_],To,_),F).
search(From,To,L,[From|Fs]):-
    flow(F),!,
    member((From,A,_),F),
    L1 is L-1,
    search(A,To,L1,Fs).

snt([],[]).
snt([A|As],[B|Bs]):-
    sentence_type(B,A),
    snt(As,Bs),!.

%-------------------------------------------------------------------------------------------------
% Predicates of the Assignment

% semtrans(As,B,Pc):
% determina o flow da conversa
% vindo de As há a probabilidade Pc de B ser escolhido
semtrans(A,B,Pc):-
    flow(F),!,
    list_ns(A,F,Ls),
    length(Ls,S),
    not(S=1),
    draw(S,R),
    nth1(R,Ls,(B,C)),
    Pc is C/100.0.

flow([
	    ([],"greetings",100),
	    (["greetings","greetings"],"askhelp",100),
	    (["greetings"],"greetings",50),
	    (["greetings"],"askhelp",50),
	    (["askhelp"],"offerhelp",100),
	    (["offerhelp"],"q1",16),
	    (["offerhelp"],"q2",17),
	    (["offerhelp"],"q3",16),
	    (["offerhelp"],"q4",17),
	    (["offerhelp"],"q5",17),
	    (["offerhelp"],"q6",17),
	    (["q1"],"a1",100),
	    (["q2"],"a2",100),
	    (["q3"],"a3",100),
	    (["q4"],"a4",100),
	    (["q5"],"a5",100),
	    (["q6"],"a6",100),
	    (["a1"],"thanks",100),
	    (["a2"],"thanks",100),
	    (["a3"],"thanks",100),
	    (["a4"],"thanks",100),
	    (["a5"],"thanks",100),
	    (["a6"],"thanks",100),
	    (["thanks"],"offerhelp",100)
	]).

% chataway(L):
% produz uma conversa de comprimento L
chataway(L) :-
    chat(L,[],_,A,[]),!,
    output(A),!.

chat(1,[T|_],[A]) -->    
    {not(T="thanks"),
     member(A,["rushedgoodbye",_])},
    type(A).
chat(1,["thanks"|_],[A]) -->
    {member(A,["goodbye",_])},
    type(A).
chat(N,Ms,[T|Ns]) -->
    {M is N-1, select(Ms,T)},
    type(T),
    chat(M,[T|Ms],Ns).

select(Ts,T) :-
    nats_down(3,Ns),!,
    member(A,Ns),
    take(A,Ts,X),
    semtrans(X,T,_).

chat_at_aim(From,To,L,_):-
    group(From,As),
    length(As,N1),!,
    chat(N1,[],Ms,From,[]),!,
    reverse(Ms,Ns),
    chat(L,Ns,_,A,To),!,
    output(From),
    output(A).

chat_at_aim(From,To,L,_):-
    sentence_type(From,A),
    sentence_type(To,B),
    search(A,B,L,[_|As]),
    snt(As,Bs),
    write_fss(Bs).
