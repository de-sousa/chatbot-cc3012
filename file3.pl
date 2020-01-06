nats_inc(N,Xs):-
    nats(N,Ys),
    reverse(Ys,Xs).

nats(0,[]).
nats(N,[N|Xs]) :-
    not(compare(<,N,1)),
    X is N-1,
    nats(X,Xs).

reverse([],[]).
reverse([X|Xs],Ys):-
    reverse(Xs,Zs),
    append(Zs,[X],Ys).

draw(N,R) :-
    nats(N,A), random_permutation(A,B),!, member(R,B).

% take(N,L1,L2)
% take takes the N first elements from list L1 and gives them in L2, in the same order
take(0,_,[]).
take(_,[],[]).
take(N,[X|Xs],[X|Ys]) :-
    M is N-1,
    take(M,Xs,Ys).


% write(Xs)
% write outputs a list of words
write_fs([]).
write_fs([X|Xs]):-
    write_f(X),
    write_fs(Xs).
write_f(A):-
    write("-"), write_fancy(A).
write_fancy([]):-
    write("\n").
write_fancy([X|Xs]):-
    write(" "),
    write(X),
    write_fancy(Xs).

group([],[]).
group(As,[Xs|Bs]):-
    append(Xs,Ys,As),
    sentence_type(Xs,_),
    group(Ys,Bs).

output(A):-
    group(A,B),
    write_fs(B).

%-------------------------------------------------------------------------------------------------

% Predicates of the Assignment





% Auxiliar Predicates

listall(_,0,[]).
listall(A,N,[A|As]):-
    M is N-1,
    listall(A,M,As).
    

sumall(_,[],0,[]).
sumall(A,[(A,B,C)|Flow],Sum,Cs):-listall((B,C),C,As), append(As,Bs,Cs), sumall(A,Flow,S1,Bs), Sum is C+S1.
sumall(A,[(B,_,_)|Flow],Sum,Cs):-not(A=B),sumall(A,Flow,Sum,Cs).

% ex:
% sentence_type(["greetings"],"greetings",C).
% C unifies with 60.

semtrans(A,B,Pc):-
    flow(F),!,
    sumall(A,F,S,Ls),
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

select(Ts,T) :-
    nats(3,Ns),!,
    member(A,Ns),
    take(A,Ts,X),
    semtrans(X,T,_).


% escolhe o próximo tipo, baseado nos que ja ocorreram: select
% sentence type gera frase desse tipo
% write: dá output à frase
chataway(L) :-
    chat(L,[],A,[]),!, output(A).

chat(1,_) --> type("goodbye"),!.
chat(N,Ms) --> {M is N-1, select(Ms,T),!}, type(T), chat(M,[T|Ms]).
