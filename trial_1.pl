answers(Words,List):-
    quick_sort(Words,Phrase),
    sentences(Sentences),
    attribution(Phrase,Sentences,List).

attribution(_,[],[]).
attribution(Words,[Ph|S],[ans(Ph,Score)|List]):-
    ratio(Words,Ph,Score),
    attribution(Words,S,List).

%-------------------------------------
ratio(Words,Phrase,Score):-
    number(Phrase,X),
    number(Words,Phrase,Y),
    Score is Y/X.

number([],0).
number([_|Xs],S) :-
    number(Xs,Z),
    S is Z+1.

number([],_,0).
number(_,[],0).
number([W|Words],[Ph|Phrase],S):-
    W=Ph,
    number(Words,Phrase,X),
    S is X+1.
number([W|Words],[Ph|Phrase],S):-
    W<Ph,
    number(Words,[Ph|Phrase],X),
    S is X.	 
number([W|Words],[Ph|Phrase],S):-
    W>Ph,
    number([W|Words],Phrase,X),
    S is X.	 
        
%-------------------------------------    
    
quick_sort([],[]).
quick_sort([X|Xs],S) :-
    compare_list(>,X,Xs,A),
    compare_list(<,X,Xs,B),
    quick_sort(A,Y),
    quick_sort(B,Z),
    append(Y,[X|Z],S).

compare_list(_,_,[],[]).
compare_list(C,X,[Y|Ys],[Y|S]):-
    compare(C,X,Y),
    compare_list(C,X,Ys,S).
compare_list(C,X,[Y|Ys],S):-
    not(compare(C,X,Y)),
    compare_list(C,X,Ys,S).
 
 
