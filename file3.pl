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

%-------------------------------------------------------------------------------------------------

% Predicates of the Assignment




% ex:
% semtrans(["greetings"],"greetings",C).
% C unifies with 60.
semtrans(A,B,Pc):-
    flow(F),!,
    list_ns(A,F,Ls),
    length(Ls,S),
    draw(S,R),
    nth1(R,Ls,(B,C)),
    Pc is C/100.0.


flow([
	    ([],"greetings",99),
	    (["greetings"],"greetings",60),
	    (["greetings"],"askhelp",39),
	    (["askhelp"],"offerhelp",99),
	    (["offerhelp"],"proposeanswerquestion",99),
	    (["proposeanswerquestion","offerhelp"],"goodbye",99),
	    (["greetings","greetings"],"askhelp",99),
	    (_,_,1)
	]).

% escolhe o próximo tipo, baseado nos que ja ocorreram: select
% sentence type gera frase desse tipo
% output: dá output à frase
chataway(L) :-
    chat(L,[],A,[]),!, output(A).

chat(1,_) --> type("goodbye"),!.
chat(N,Ms) --> {M is N-1, select(Ms,T),!}, type(T), chat(M,[T|Ms]).

select(Ts,T) :-
    nats_down(3,Ns),!,
    member(A,Ns),
    take(A,Ts,X),
    semtrans(X,T,_).

