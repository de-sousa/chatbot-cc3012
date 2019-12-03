sentence_type(L,T) :-
    type(T,L,_).

type(T) --> usefulword(T), uselessword(T).
usefulword(T) --> ["hello"], {getType(1,T)}.
uselessword(T) --> [_], uselessword(T),!.
uselessword(T) --> [_], usefulword(T),!.
uselessword(_) --> [].

getType(1,"greetings").
    
