% ex:
% sentence_type(["hello","bot"],T).
% T unifies with "greetings".

sentence_type(L,T) :-
    type(T,L,_).

type(T) -->  usefulword(T),! ; [_],type(T),!.
%-- greetings
usefulword("greetings") --> ["hello"]; ["hi"].
%-- help
usefulword("offerhelp") --> ["help"]; ["need"].
%-- examples
usefulword("offerexample") --> ["example"]; ["ex"].
