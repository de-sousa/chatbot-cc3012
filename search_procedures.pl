bfs(Goal,[[Goal|Path]|_],[Goal|Path],C):-
    length([Goal|Path],L),
    not(compare(<,L,C)).
bfs("goodbye",A,["goodbye"|B],C):-
    C1 is C-1,
    bfs("thanks",A,B,C1).
bfs("rushedgoodbye",[[A]],["rushedgoodbye",A],_).
bfs(Goal,[Path|Paths],Sol,L) :-
    expand(Path,ExpPaths),
    append(Paths,ExpPaths,Paths2),
    bfs(Goal,Paths2,Sol,L),!.

expand([First|Path],ExpPaths) :-
    flow(F),
    findall([Next,First|Path],
	    (member(([First|_],Next,_),F),not(member(Next,[First|Path]))
	    ),
	    ExpPaths).
