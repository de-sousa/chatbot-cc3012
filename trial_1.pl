% --------------------------------------------------------
% answers/2 : answers(Words,List)
% - answers/2 prepara a lista de palavras, Words, para ser
% analisada pelo attribution/3. sentences/1 é um facto que
% corresponde ao array com todas as respostas possíveis.
answers(Words,[ans(["I'm","sorry,","can","you","repeat?"],1)]):-
    quick_sort(Words,Phrase),
    sentences(Sentences),
    attribution(Phrase,Sentences,[]),!.
answers(Words,List):-
    quick_sort(Words,Phrase),
    sentences(Sentences),
    attribution(Phrase,Sentences,List),!.

% --------------------------------------------------------------
% attribution/3 : attribution(Words,BaseDeDados,PossibleAnswers)
% - attribution/3 analisa a BaseDeDados e as PossibleAnswers
% contêm o tuplo ans(Frase,Ratio), em que Ratio (>0) corresponde
% à pontuação atribuída à Frase.
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
% ratio/3 : ratio(Lista1,Lista2,Score)
% - Score é a divisão do número de palavras em Lista1 que
% estão em Lista2 pelo número de palavras em Lista2.
ratio(Words,Phrase,Score):-
    number(Phrase,X),
    number(Words,Phrase,Y),
    Score is Y/X,!.

% --------------------------------------------------------
% number/2 : (Lista,N)
% - N é o número de elementos de Lista
number([],0).
number([_|Xs],S) :-
    number(Xs,Z),
    S is Z+1,!.

% --------------------------------------------------------
% number/3 : number(Lista1,Lista2,N)
% - N é o número de elementos da interseção de Lista1 com
% Lista2. Esta definição funciona porque ambas as Listas
% estão ordenadas.
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
% quick_sort/2 : quick_sort(L1,L2)
% - L2 corresponde ao array ordenado L1, sem elementos
% repetidos.
quick_sort([],[]).
quick_sort([X|Xs],S) :-
    compare_list(>,X,Xs,A),
    compare_list(<,X,Xs,B),
    quick_sort(A,Y),
    quick_sort(B,Z),
    append(Y,[X|Z],S).

% --------------------------------------------------------
% compare_list/4 : compare_list(Op,El,L1,L2)
% - L2 contém todos os elementos L de L1 tal que El `Op` L,
% por exemplo, caso Op=<, L2 contém todos os elementos de
% L1 maiores que El.
compare_list(_,_,[],[]).
compare_list(C,X,[Y|Ys],[Y|S]):-
    compare(C,X,Y),
    compare_list(C,X,Ys,S).
compare_list(C,X,[Y|Ys],S):-
    not(compare(C,X,Y)),
    compare_list(C,X,Ys,S).

% --------------------------------------------------------
% best_answer/2 : best_answer(Poss,Best)
% - Best corresponde à resposta S tal que o par(ans(S,X))
% pertence a Poss em que X é o maior score.
best_answer([ans(Str,_)],Str).
best_answer(List,S):-
    best_answer_add(List,S,_).

% --------------------------------------------------------
% best_answer_add/3
% - função auxiliar de best_answer.
best_answer_add([ans(Str,Sco)],Str,Sco).
best_answer_add([ans(Str,Sco)|Ans],Str,Sco):-
    best_answer_add(Ans,_,X),
    Sco>X,!.
best_answer_add([ans(_,Sco)|Ans],S,X):-
    best_answer_add(Ans,S,X),
    not(Sco>X),!.

% --------------------------------------------------------
% runifanswer/2 : runifanswer(S,A)
% - A é uma escolha aleatória das frase possíveis em S,
% com igual distribuição.
runifanswer(Sen,Ans):-
    answers(Sen,List),
    length(List,X),
    S is X-1,
    random_between(0,S,R),
    nth0(R,List,ans(Ans,_)).

% --------------------------------------------------------
% rpropanswer/2 : rpropanswer(S,A)
% - A é uma escolha aleatória das respostas possíveis em
% S, tendo em conta o score de cada resposta.
rpropanswer(Sen,Ans):-
    answers(Sen,List),
    sum_score(List,X),
    random(0,X,Y),
    select_score(Y,List,Ans).

% --------------------------------------------------------
% sum_score/2 : sum_score(L,S)
% S contém a soma de todos os scores das respostas em L.
sum_score([],0).
sum_score([ans(_,Score)|Ls],X):-
    sum_score(Ls,Y),
    X is Score+Y.

% --------------------------------------------------------
% select_score/3 : select_score(V,L,A)
% - A contém a resposta dependendo da posição de V no
% segmento de reta [0,soma dos scores das respostas em L].
% Quanto maior for o score de A, maior é a probabilidade
% de A ser escolhido.
select_score(Y,[ans(_,Sco)|List],Ans):-
    Y>Sco,
    X is Y-Sco,
    select_score(X,List,Ans),!.
select_score(Y,[ans(Sen,Sco)|_],Sen):-
    Sco>=Y,!.

% --------------------------------------------------------
% read_line/1 : read_line(Str)
% - Lê Str, uma string, do Input.
read_line(Str) :-
    current_input(Input),
    read_string(Input,"\n"," .,!?",_,Str).

% --------------------------------------------------------
% chat/1 : chat(X)
% - Inicia a conversa com o chatbot, e X contém a string
% correspondente a toda a conversa.
chat(X) :-
    chat("",X).

% --------------------------------------------------------
% chat/2 : chat(L1,L2)
% - L2 contém toda a conversa. L1 contém a conversa até ao
% momento atual e eventualmente unificará com L2.
chat(X,Last) :-
    read_line(Input),
    string_lower(Input,In),
    string_chars(Input,Is),
    string_chars(X,Xs),
    append(Is,['\n'],I1s),
    append(Xs,I1s,Ys),
    string_chars(Y,Ys),
    split_string(In," "," ",InLs),
    chat(InLs,Y,Last),!.

% --------------------------------------------------------
% chat/3 : chat(Input,L1,L2)
% - Caso o utilizador queira terminar a conversa, analisando
% o Input, atualizará L1 com o Output correspondente e
% direcionará o programa para chat_exit/2
chat(Input,X,Last):-
    rpropanswer(Input,S),
    split_string("Are you sure you want to leave?"," "," ",S),
    write("Are you sure you want to leave?\n"),
    string_chars("Are you sure you want to leave?\n",Ss),
    string_chars(X,Xs),
    append(Xs,Ss,Ys),
    string_chars(Y,Ys),
    chat_exit(Y,Last).

% --------------------------------------------------------
% chat/3 : chat(Input,L1,L2)
% - Avalia o Input, escolhendo o melhor Output, que será
% adicionado a X. L2 contém a string correspondente a toda
% a conversa
chat(Input,X,Last):-
    rpropanswer(Input,Output),
    split_string("Are you sure you want to leave?"," "," ",S),
    not(compare(=,Output,S)),
    write_list(Output),
    wordls_to_chls(Output,Os),
    string_chars(X,Xs),
    append(Xs,Os,Ys),
    string_chars(Y,Ys),
    chat(Y,Last). 

% --------------------------------------------------------
% chat_exit/2 : chat_exit(L1,L2)
% - L2 contém toda a conversa. L1 contém a conversa até ao
% momento atual e eventualmente unificará com L2. A
% diferença de chat/2 para chat_exit/2 é que chat_exit/2
% avalia se o utilizador quer realmente terminar a conversa.
chat_exit(X,Last) :-
    read_line(Input),
    string_lower(Input,In),
    string_chars(Input,Is),
    string_chars(X,Xs),
    append(Is,['\n'],I1s),
    append(Xs,I1s,Ys),
    string_chars(Y,Ys),
    split_string(In," "," ",InLs),
    chat_exit(InLs,Y,Last),!.

chat_exit(Input,X,Y):-
    ex_ans(Input,[ans(S,_)]),
    split_string("Bye!"," "," ",S),
    write("Bye!\n"),
    string_chars("Bye!",Is),
    string_chars(X,Xs),
    append(Xs,Is,Ys),
    string_chars(Y,Ys),!.
chat_exit(Input,X,Last):-
    ex_ans(Input,[ans(S,_)]),
    split_string("Thank you! In what can i help you?"," "," ",S),
    string_chars("Thank you! In what can i help you?",Is),
    string_chars(X,Xs),
    append(Xs,Is,Ys),
    string_chars(Y,Ys),  
    write_list(S),!,
    chat(Y,Last).
chat_exit(_,X,Last):-
    write("I'm sorry, can you repeat?"),!,
    string_chars("I'm sorry, can you repeat?",Is),
    string_chars(X,Xs),
    append(Xs,Is,Ys),
    string_chars(Y,Ys),
    chat_exit(X,Y,Last).

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

wordls_to_chls([],['\n']).
wordls_to_chls([X|Xs],CharLs):-
    string_chars(X,Ls1),
    wordls_to_chls(Xs,CharLs1),
    append(Ls1,[' '],Ls),
    append(Ls,CharLs1,CharLs).

% --------------------------------------------------------
% --------------------Base de Dados-----------------------
sentences(
    [("hello hi salut","hello user"),
     ("dear hello hi","how nice! hello beautiful user!"),
     ("are how you","i'm fine"),
     ("bye","Are you sure you want to leave?")
    ]).

ex_sentences(
    [("s sim y yes","Bye!"),
     ("n não nein no","Thank you! In what can i help you?")
    ]).


% --------------------------------------------------------
% stats/1 => Takes a list with a conversation and prints out stats from that convers.
stats(X) :-
    string_lower(X,Xs),
    split_string(Xs,"\n"," ",Xss),
    length(Xss,Length),
    write("Length of the conversation: "),
    write(Length),
    write(".\n"),!,
    stats_words(Xss,NWords),
    write("Total number of words: "),
    write(NWords),
    write(".\n"),
    stats_freq(Xss,Ls),
    write("Word Frequency is:\n"),
    write_ls(Ls,NWords),!.

stats_words([],0).
stats_words([""|Xs],M):-
    stats_words(Xs,M).
stats_words([X|Xs], N) :-
    not(X=""),
    stats_words(Xs,M),
    split_string(X," ",",.!?",Y),
    length(Y,L),
    N is L+M.

stats_freq([],[]).
stats_freq([X|Xss],Ls):-
    stats_freq(Xss,Ms),
    split_string(X," "," .,!?",Y),
    stats_freq(Y,Ms,Ls).

stats_freq([],Ms,Ms).
stats_freq([X|Xs],Ms,Ls):-
    stats_freq(Xs,Ms,Ns),
    add(X,Ns,Ls).

add(X,[],[(X,1)]).
add(X,[(X,N)|Ms],[(X,M)|Ms]) :-
    M is N+1,!.
add(X,[(Y,N)|Ms],[(Y,N)|Ns]):-
    not(X=Y),
    add(X,Ms,Ns),!.

write_ls([],_).
write_ls([(L1,L2)|Ls],NWords) :-
    write("- "),
    write(L1),
    write(": "),
    F is L2/NWords,
    write(F),
    write("%\n"),!,
write_ls(Ls,NWords).
