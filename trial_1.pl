% --------------------------------------------------------
% answers(Words,List) => Words
answers(Words,[ans(["I'm","sorry,","can","you","repeat?"],1)]):-
    quick_sort(Words,Phrase),
    sentences(Sentences),
    attribution(Phrase,Sentences,[]),!.
answers(Words,List):-
    quick_sort(Words,Phrase),
    sentences(Sentences),
    attribution(Phrase,Sentences,List),!.

% --------------------------------------------------------
% attribution(Words,Database,PossibleAnswers) => attribution analisa a
% Base de Dados e as PossibleAnswers contêm o tuplo ans(Frase,Ratio),
% em que Ratio (>0) corresponde à pontuação atribuída à Frase
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

% --------------------------------------------------------
% ratio(Lista1,Lista2,Score) => Score é o rácio de nrs de palavras em
% Lista1 que estão em Lista2 sobre o nr de eltos de Lista2.
ratio(Words,Phrase,Score):-
    number(Phrase,X),
    number(Words,Phrase,Y),
    Score is Y/X,!.

% --------------------------------------------------------
% number(Lista,N) => N é o número de elementos.
number([],0).
number([_|Xs],S) :-
    number(Xs,Z),
    S is Z+1,!.

% --------------------------------------------------------
% number(Lista1,Lista2,N) => N é o número de eltos que
% tais que se pertencem a Lista1, pertencem a Lista2.
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

% --------------------------------------------------------
% quicksort(L1,L2) => Simple sorting, por ordem crescente.
% Elementos iguais, são removidos, ficando só um representante.
quick_sort([],[]).
quick_sort([X|Xs],S) :-
    compareList(>,X,Xs,A),
    compareList(<,X,Xs,B),
    quick_sort(A,Y),
    quick_sort(B,Z),
    append(Y,[X|Z],S).

compareList(_,_,[],[]).
compareList(C,X,[Y|Ys],[Y|S]):-
    compare(C,X,Y),
    compareList(C,X,Ys,S).
compareList(C,X,[Y|Ys],S):-
    not(compare(C,X,Y)),
    compareList(C,X,Ys,S).

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

rpropanswer(Sen,Ans):-
    answers(Sen,List),
    sum_score(List,X),
    random(0,X,Y),
    select_score(Y,List,Ans).

sum_score([],0).
sum_score([ans(_,Score)|Ls],X):-
    sum_score(Ls,Y),
    X is Score+Y.

select_score(Y,[ans(_,Sco)|List],Ans):-
    Y>Sco,
    X is Y-Sco,
    select_score(X,List,Ans),!.
select_score(Y,[ans(Sen,Sco)|_],Sen):-
    Sco>Y,!.

read_line(Words) :-
    current_input(Input),
    read_string(Input,"\n"," .,!?",_,String),
    split_string(String," "," ",Words).

chat :- read_line(Input), chat(Input),!.

chat(Input):-
    rpropanswer(Input,S),
    split_string("Are you sure you want to leave?"," "," ",S),!,
    write_list(S),
    chat_exit.
chat(Input):-
    rpropanswer(Input,Output),
    split_string("Are you sure you want to leave?"," "," ",S),
    not(compare(=,Output,S)),
    write_list(Output),
    chat. 

chat_exit :- read_line(Input), chat_exit(Input),!.

chat_exit(Input):-
    ex_ans(Input,[ans(S,_)]),
    split_string("bye! hope to see you soon!"," "," ",S),
    write_list(S),!.
chat_exit(Input):-
    ex_ans(Input,[ans(S,_)]),
    split_string("thank you! in what can i help you?"," "," ",S),
    write_list(S),!,
    chat.
chat_exit(_):-
    write("I'm sorry, can you repeat?"),!,
    chat_exit.

ex_ans(Words,List):-
    quick_sort(Words,Phrase),
    ex_sentences(Sentences),
    attribution(Phrase,Sentences,List),!.
    
write_list([X]):-
    write(X),
    write("\n"),!.
write_list([X|Xs]):-
    write(X),
    write(" "),
    write_list(Xs).

% --------------------------------------------------------
% --------------------Base de Dados-----------------------
sentences(
    [("hello hi salut","hello user"),
     ("dear hello hi","how nice! hello beautiful user!"),
     ("are how you","i'm fine"),
     ("bye","Are you sure you want to leave?")
    ]).

ex_sentences(
    [("s sim y yes","bye! hope to see you soon!"),
     ("n não nein no","thank you! in what can i help you?")
    ]).


% --------------------------------------------------------
% stats/1 => Takes a list with a conversation and prints out stats from that convers.
stats(Xss) :-
    statsAux(Xss,Length),
    write("Length of the conversation: "),
    write(Length),
    write(".\n").

statsAux([],Length) :-
    Length is 0.
   
statsAux([_|Xss],Length) :-
    statsAux(Xss,M),
    Length is M+1.
    
