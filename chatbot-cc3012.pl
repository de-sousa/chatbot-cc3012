bot :- read_line(Input), bot(Input).

% read_line/1 --------
% Words - the list of words
% read from the Input
read_line(Words) :-
    current_input(Input),
    read_string(Input,"\n"," .,!?",_,String),
    split_string(String," "," ",Words).

% bot/1 --------------
% it's the chat bot! it
% will connect the X-coordinate
% to the Input, search the (X,Y)
% pair and then connect the
% Y-coordinate to the Output
bot(Input) :-
    find(X,Y),
    connect(X,Map,Input),
    connect(Y,Map,Output),
    write(Output).
 
% connect/3 ----------
connect([X|Words1],Map,List) :-
    integer(X),
    search(X,Map,Y),
    append(Y,Words2,List),
    connect(Words1,Map,Words2). 
connect([Word|Words1],Map,[Word|Words2]) :-
    connect(Words1,Map,Words2).
connect([],_,[]).

% search/3 ----------
search(X,[(X,Y)|_],Y).
search(X,[(X1,_)|Map],Y) :-
    not(X=X1),
    search(X,Map,Y).

% (X,Y) -------------
find(["hello", 1],["hello", "for", "you", "too,", 1]).
    
