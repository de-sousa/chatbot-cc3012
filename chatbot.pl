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
% - Analisando o Input, chat/3 atualizará L1 com o Output
% correspondente. L2 contém toda a conversa e eventualmente
% unificará com L1. Caso o utilizador queira terminar a
% conversa, direcionará o programa para chat_exit/2.
chat(Input,X,Last):-
    rpropanswer(Input,S),
    split_string("Are you sure you want to leave?"," "," ",S),
    write("Are you sure you want to leave?\n"),
    string_chars("Are you sure you want to leave?\n",Ss),
    string_chars(X,Xs),
    append(Xs,Ss,Ys),
    string_chars(Y,Ys),
    chat_exit(Y,Last).
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

% --------------------------------------------------------
% chat_exit/3 : chat_exit(In,L1,L2)
% - L2 contém toda a conversa. Caso o utilizador queira
% de facto sair do programa, L1, com o último Output
% adicionado, unifica com L2. Caso contrário tudo se mantém
% e o programa é redirecionado para chat/2
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

% --------------------------------------------------------
% ex_ans/2 : ex_ans(Words,List)
% - Igual a answers/2, a única diferença é que ex_ans/1 é
% um facto que apenas contém as respostas possíveis de
% saída.
ex_ans(Words,List):-
    quick_sort(Words,Phrase),
    ex_sentences(Sentences),
    attribution(Phrase,Sentences,List),!.

% --------------------------------------------------------
% write_list/1 :
% - Escreve cada elemento do seu argumento no output
% padrão, com um ' ' entre eles e terminando com um '\n'
write_list([X]):-
    write(X),
    write("\n"),!.
write_list([X|Xs]):-
    write(X),
    write(" "),
    write_list(Xs).

% --------------------------------------------------------
% wordls_to_chls/2 : wordls_to_chls(W,L)
% - L é a lista dos caracteres de W por ordem, sendo W uma
% lista de palavras
wordls_to_chls([],['\n']).
wordls_to_chls([X|Xs],CharLs):-
    string_chars(X,Ls1),
    wordls_to_chls(Xs,CharLs1),
    append(Ls1,[' '],Ls),
    append(Ls,CharLs1,CharLs).

% --------------------------------------------------------
% --------------------Base de Dados-----------------------
sentences([
     %-basics
     ("hello hi salut","Hello, user!"),
     ("are good how ok you","I'm good, and you?"),
     ("are good how ok you","It's everything fine! Thanks for asking! And with you?"),
     ("answer life to","42!"),
     ("abort bye leave","Are you sure you want to leave?"),
     ("example","Can't answer you that, yet. I'm working on it!"),
     %----------------
     ("split_string","split_string(+String,+SepChars,+PadChars,-SubString)\nBreak String into SubStrings.\nThe SepChars argument provides the characters that act as separators and thus the length of SubStrings is one more than the number of separators found if SepChars and PadChars do not have common characters. If SepChars and PadChars are equal, sequences of adjacent separators act as a single separator. Leading and trailing characters for each substring that appear in PadChars are removed from the substring. The input arguments can be either atoms, strings or char/code lists."),
     ("string_split","I think you misspelled the predicate. Try split_string."),
     ("is","X is Y % X is the value that results from simplifying the Y as an arithmetic expression. Attempts unification of variable X to the value of Y."),
     ("=:=","X =:= Y % X and Y evaluate to the same arithmetic value. No unification."),
     ("=","X = Y % Can X and Y be unified into the same value? If so, unify them."),
     ("\\=","X \\= Y % Would unifying X and Y fail?"),
     ("==","X == Y % Are X and Y already the same value?"),
     ("\\==","X \\== Y % Are X and Y different?"),
     ("isempty","isEmpty([])."),
     ("singleton","singleton([X])."),
     ("hastwo","hasTwo([X, Y])."),
     ("atleasttwo","atLeastTwo([X, _])."),
     ("last","last(Xs, LastX)."),
     ("element","element(Index, Integers, Value). % Value is the Indexth element of Integers. Only works with 1-indexed and with integers"),
     ("nth0","nth0(Index, Values, Value). % 0-indexed Values. Value is the Indexth element. See also nth1"),
     ("length","length(Xs, Count). % Count is the length of the list Xs"),
     ("reverse","reverse(Xs, Reversed)."),
     ("append","append(Xs, Ys, XsThenYs)."),
     ("flatten","flatten(Nested, Flat). % Remove all but outermost \"[\" and \"]\" from nested list"),
     ("write","write(X). % Write X to the current output."),
     ("read","read(X). % Read the next Prolog term from the current input stream and unify with X."),
     ("abs","abs(Expr) % Evaluate Expr and return the absolute value of it"),
     ("nl","Write a newline to the current output stream."),
     ("put","put(Char) % Write a Char to the current output stream"),
     ("tab","tab(N) % Write N spaces on the current output stream"),
     ("get_char","get_char(Char) % Read the current input stream and unify Char with the next character as a one-character atom."),
     ("findall","findall(Template,Goal,Bag) % Create a list of the instantiations Template gets successively on backtracking over Goal and unify the result with Bag. Succeeds with an empty list if Goal has no solutions."),
     ("bagof","bagof(Template,Goal,Bag) % Unify Bag with the alternatives of Template. If Goal has free variables besides the one sharing with Template, bagof/3 will backtrack over the alternatives of these free variables, unifying Bag with the corresponding alternatives of Template."),
     ("acess_file","access_file(File,Mode) % True if File exists and can be accessed by this Prolog process under mode Mode. Mode is one of the atoms read, write, append, exist, none or execute."),
     ("exists_file","exists_file(File) % True if File exists and is a regular file. This does not imply the user has read or write access to the file."),
     ("delete_file","delete_file(File) % Remove File from the file system."),
     ("rename_file","rename_file(File1,File2) % Rename File1 as File2."),
     ("size_file","size_file(File,Size) % Unify Size with the size of File in bytes."),
     ("halt","Terminate Prolog execution."),
     ("assert","assert(Term) % Assert a clause (fact or rule) into the database.
     The deprecated assert/1 is equivalent to assertz/1."),
     ("assertz","assertz(Term) % Asserts the clause as last clause."),
     ("asserta","asserta(Term) % Asserts the clause as first clause of the predicate."),
     ("retract","retract(Term) % When Term is an atom or a term it is unified with the first unifying fact or clause in the database. Then, the fact or clause is removed from the database."),
     ("line_count","line_count(Stream,Count) % Unify Count with the number of lines read or written. Counting starts at 1."),
     ("character_count","character_count(Stream,Count) % Unify Count with the current character index. For input streams this is the number of characters read since the open; for output streams this is the number of characters written. Counting starts at 0."),
     ("line_position","line_position(Stream,Count) % Unify Count with the position on the current line. Note that this assumes the position is 0 after the open. Tabs are assumed to be defined on each 8-th character, and backspaces are assumed to reduce the count by one, provided it is positive."),
     ("garbage_collect","Invoke the global and trail stack garbage collector. Normally the garbage collector is invoked automatically if necessary. Explicit invocation might be useful to reduce the need for garbage collections in time-critical segments of the code. After the garbage collection trim_stacks/0 is invoked to release the collected memory resources."),
     ("garbage_collect_atoms","Reclaim unused atoms. Normally invoked after agc_margin (a Prolog flag) atoms have been created. On multithreaded versions the actual collection is delayed until there are no threads performing normal garbage collection. In this case garbage_collect_atoms/0 returns immediately. Note that there is no guarantee it will ever happen, as there may always be threads performing garbage collection."),
     ("garbage_collect_clauses","Reclaim retracted clauses. During normal operation, retracting a clause implies setting the erased generation to the current generation of the database and increment the generation. Keeping the clause around is both needed to realise the logical update view and deal with the fact that other threads may be executing the clause. Both static and dynamic code is processed this way."),
     ("trim_stacks","Release stack memory resources that are not in use at this moment, returning them to the operating system. It can be used to release memory resources in a backtracking loop, where the iterations require typically seconds of execution time and very different, potentially large, amounts of stack space."),
     ("shell","shell(Command,Status) % Execute Command on the operating system. Command is given to the Bourne shell (/bin/sh). Status is unified with the exit status of the command."),
     ("getenv","getenv(Name,Value) % Get environment variable. Fails silently if the variable does not exist. Please note that environment variable names are case-sensitive on Unix systems and case-insensitive on Windows."),
     ("setenv","setenv(Name,Value) % Set an environment variable. Name and Value must be instantiated to atoms or integers. The environment variable will be passed to shell/[0-2] and can be requested using getenv/2."),
     ("unsetenv","unsetenv(Name) % Remove an environment variable from the environment. Some systems lack the underlying unsetenv() library function. On these systems unsetenv/1 sets the variable to the empty string."),
     ("setlocale","setlocale(Category,Old,New) % Set/Query the locale setting which tells the C library how to interpret text files, write numbers, dates, etc. Category is one of all, collate, ctype, messages, monetary, numeric or time. For details, please consult the C library locale documentation."),
     ("unix","unix(Command) % his predicate comes from the Quintus compatibility library and provides a partial implementation thereof. It provides access to some operating system features and unlike the name suggests, is not operating system specific. Defined Command's are below.

system(+Command)
    Equivalent to calling shell/1. Use for compatibility only.
shell(+Command)
    Equivalent to calling shell/1. Use for compatibility only.
shell
    Equivalent to calling shell/0. Use for compatibility only.
cd
    Equivalent to calling working_directory/2 to the expansion (see expand_file_name/2) of ~. For compatibility only.
cd(+Directory)
    Equivalent to calling working_directory/2. Use for compatibility only.
argv(-Argv)
    Unify Argv with the list of command line arguments provided to this Prolog run. Please note that Prolog system arguments and application arguments are separated by --. Integer arguments are passed as Prolog integers, float arguments and Prolog floating point numbers and all other arguments as Prolog atoms. New applications should use the Prolog flag argv. See also the Prolog flag argv."),
     ("win_exec","win_exec(Command,Show) % Windows only. Spawns a Windows task without waiting for its completion. Show is one of the Win32 SW_* constants written in lowercase without the SW_*: hide maximize minimize restore show showdefault showmaximized showminimized showminnoactive showna shownoactive shownormal. In addition, iconic is a synonym for minimize and normal for shownormal."),
     ("win_shell","win_shell(Operation,File,Show) % Windows only. Opens the document File using the Windows shell rules for doing so. Operation is one of open, print or explore or another operation registered with the shell for the given document type. On modern systems it is also possible to pass a URL as File, opening the URL in Windows default browser. This call interfaces to the Win32 API ShellExecute(). The Show argument determines the initial state of the opened window (if any). See win_exec/2 for defined values."),
     ("get_time","get_time(TimeStamp) % Return the current time as a TimeStamp. The granularity is system-dependent."),
     ("char_conversion","char_conversion(CharIn,CharOut) % Define that term input (see read_term/3) maps each character read as CharIn to the character CharOut."),
     ("read_term","read_term(Stream,Term,Options) % Read term with options from Stream."),
     ("is_dict","is_dict(Term) % True if Term is a dict."),
     ("get_dict","get_dict(Key,Dict,Value) % Unify the value associated with Key in dict with Value. If Key is unbound, all associations in Dict are returned on backtracking. The order in which the associations are returned is undefined. This predicate is normally accessed using the functional notation Dict.Key."),
     ("select_dict","select_dict(Select,From,Rest) % True when the tags of Select and From have been unified, all keys in Select appear in From and the corresponding values have been unified. The key-value pairs of From that do not appear in Select are used to form an anonymous dict, which us unified with Rest."),
     ("nth","nth(List,N,Term) % Term is the Nth term in the list."),
     ("member","member(X,Xs) % True if X is in the list Xs.")
     	     ]).

ex_sentences(
    [("s sim y yes","Bye!"),
     ("n não nein no","Thank you! In what can I help you?")
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
