bfs(Goal,[[Goal|Path]|_],[Goal|Path]).
bfs(Goal,[Path|Paths],Sol) :-
    expand(Path,ExpPaths),
    append(Paths,ExpPaths,Paths2),
    bfs(Goal,Paths2,Sol),!.

expand([First|Path],ExpPaths) :-
    findall([Next,First|Path],
	    (transition(First,Next),not(member(Next,[First|Path]))
	    ),
	    ExpPaths).

hillclimbing(Goal,h([Goal|Path],_),[Goal|Path]).
hillclimbing(Goal,h(Path,_),Sol) :-
    expandh(Path,Goal,HExpPaths),
    bestpath(HExpPaths,BestPath),
    hillclimbing(Goal,BestPath,Sol),!.

bestpath([Path],Path).
bestpath([Path|HPaths],BestPath2) :-
    bestpath(HPaths,BestPath1),
    aux_bestpath(Path,BestPath1,BestPath2),!.

aux_bestpath(h(P1,H1),h(_,H2),h(P1,H1)) :- H1>H2,!.
aux_bestpath(h(_,H1),h(P2,H2),h(P2,H2)) :- H1=<H2,!.


bestfirst(Goal,[h([Goal|Path],_)|_],[Goal|Path]).
bestfirst(Goal,[h(Path,_)|Paths],Sol) :-
    expandh(Path,Goal,HExpPaths),
    insert(HExpPaths,Paths,Paths2),
    bestfirst(Goal,Paths2,Sol),!.

expandh([First|Path],Goal,ExpPaths) :-
    findall(h([Next,First|Path],H),
        (transition(First,Next),
         not(member(Next,[First|Path])),
         heuristic(Next,Goal,H)),
        ExpPaths).

heuristic(Next,Goal,H) :-
    atom_chars(Next,LA),
    atom_chars(Goal,LB),
    nequal(LA,LB,H).

insert([],L,L).
insert([HPath|HPaths],HExpPaths,HExpPaths3) :-
    aux_insert(HPath,HExpPaths,HExpPaths2),
    insert(HPaths,HExpPaths2,HExpPaths3),!.

aux_insert(HPath,[],[HPath]).
aux_insert(h(Path,H),[h(Path2,H2)|HExpPaths],[h(Path,H),h(Path2,H2)|HExpPaths]) :- H>=H2,!.
aux_insert(h(Path,H),[h(Path2,H2)|HExpPaths],[h(Path2,H2)|HExpPaths2]) :-
    H<H2,
    aux_insert(h(Path,H),HExpPaths,HExpPaths2).
