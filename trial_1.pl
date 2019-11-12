answers(Words,List):-
    quick_sort(Words,Phrase),
    sentences(Sentences),
    attribution(Phrase,Sentences,List),!.

attribution(_,[],[]).
attribution(Words,[(Ph,Ans)|S],[ans(Ans1,Score)|List]):-
    split_string(Ph," "," ",Ph1),
    ratio(Words,Ph1,Score),
    Score>0,
    split_string(Ans," "," ",Ans1),
    attribution(Words,S,List),!.
attribution(Words,[(Ph,_)|S],List):-
    split_string(Ph," "," ",Ph1),
    ratio(Words,Ph1,Score),
    Score=0,
    attribution(Words,S,List),!.

ratio(Words,Phrase,Score):-
    number(Phrase,X),
    number(Words,Phrase,Y),
    Score is Y/X,!.

number([],0).
number([_|Xs],S) :-
    number(Xs,Z),
    S is Z+1,!.

number([],_,0).
number(_,[],0).
number([W|Words],[Ph|Phrase],S):-
    compare(=,W,Ph),
    number(Words,Phrase,X),
    S is X+1,!.
number([W|Words],[Ph|Phrase],S):-
    compare(<,W,Ph),
    number(Words,[Ph|Phrase],X),
    S is X,!.
number([W|Words],[Ph|Phrase],S):-
    compare(>,W,Ph),
    number([W|Words],Phrase,X),
    S is X,!.

sentences(
    [("hello hi salut","hello user"),
     ("dear hello hi","how nice! hello beautiful user!"),
     ("are how you","i'm fine")
    ]).

% -------------------------------------
quick_sort(L,SL) :- quicksort_dl(L,SL-[]).

quick_sort_dl([],L-L).
quick_sort_dl([A|R],SL-RSL) :-
  partition(A,R,L1,L2),
  quicksort_dl(L1,SL-[A|R2]),
  quicksort_dl(L2,R2-RSL).

partition(A,[],[],[]).
partition(A,[X|L1],[X|R1],R2) :-
  X=<A,partition(A,L1,R1,R2), !.
partition(A,[X|L1],R1,[X|R2]) :-
  X>A,partition(A,L1,R1,R2), !.

%-------------------------------------

best_answer([ans(Str,_)],Str).
best_answer(List,S):-
    best_answer_add(List,S,_).

best_answer_add([ans(Str,Sco)],Str,Sco).
best_answer_add([ans(Str,Sco)|Ans],Str,Sco):-
    best_answer_add(Ans,_,X),
    Sco>X,!.
best_answer_add([ans(_,Sco)|Ans],S,X):-
    best_answer_add(Ans,S,X),
    not(Sco>X),!.

runifanswer(Sen,Ans):-
    answers(Sen,List),
    length(List,X),
    S is X-1,
    random_between(0,S,R),
    nth0(R,List,ans(Ans,_)).
