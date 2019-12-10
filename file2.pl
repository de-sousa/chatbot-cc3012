% ex:
% sentence_type(["hello","bot"],T).
% T unifies with "greetings".

sentence_type(L,T) :-
    type(T,L,_).

type(T) --> [_],type(T),!; usefulword(T),!.
%-- greetings
usefulword(T) --> ["hello"], {getType(1,T)}.
usefulword(T) --> ["hi"], {getType(1,T)}.
%-- help
usefulword(T) --> ["help"],{getType(2,T)}.
usefulword(T) --> ["need"],{getType(2,T)}.
%-- examples
usefulword(T) --> ["example"], {getType(3,T)}.
usefulword(T) --> ["ex"], {getType(3,T)}.



getType(1,"greetings").
getType(2,"offerhelp").
getType(3,"offerexample").
    
