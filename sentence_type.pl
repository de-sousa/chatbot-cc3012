% sentence_type(L,T)
% sentence_type generates/classifies a sentence S from/to a given type T
sentence_type(S,T):-
   type(T,S,[]).

% greetings
type("greetings") -->  {draw(2,r)}, hi(r), {draw(4,t)}, to(t).

hi(1) --> ["hi"].
hi(2) --> ["hello"].

to(1) --> ["chatbot"].
to(2) --> ["dear"], ["friend"].
to(3) --> ["friend"].
to(4) --> [].


% askhelp
type("askhelp") --> {draw(3,r),draw(4,t)}, modalverb(r),chatbot(t),["help"],["me?"].

modalverb(1) --> ["can"].
modalverb(2) --> ["could"].
modalverb(3) --> ["might"].

chatbot(1) --> ["you"].
chatbot(2) --> ["you,","please,"].
chatbot(2) --> ["the"], ["chatbot"].
chatbot(4) --> ["the"], ["chatbot,"], ["please,"].


% offerhelp
type("offerhelp") -->
    {draw(2,r), draw(3,t)}, accepting(r), asking(t).

accepting(1) --> ["of"],["course!"].
accepting(2) --> ["yes!"].

asking(1) --> {draw(2,r)}, ["in"], ["what"], a(r), ["need"], ["help?"].
asking(2) --> ["where"], ["can"], ["i"], ["be"], ["useful?"].
asking(3) --> {draw(2,r)}, ["just"], ["tell"], ["me"], ["what"], b(r), ["to"], ["know."].

a(1) --> ["do"], ["you"].
a(2) --> ["does"], ["the"], ["human"].

b(1) --> ["the"], ["human"], ["needs"].
b(2) --> ["you"], ["need"].


% proposequestion
type("proposequestion") --> ["What"],["does"],["the"],["append"],["predicate"],["do?"].


% greetings
type("greetings") -->  {draw(2,R)}, hi(R), {draw(4,T)}, to(T).

hi(1) --> ["hi"].
hi(2) --> ["hello"].

to(1) --> ["chatbot"].
to(2) --> ["dear"], ["friend"].
to(3) --> ["friend"].
to(4) --> [].


% askhelp
type("askhelp") --> {draw(3,R),draw(4,T)}, modalverb(R),chatbot(T),["help"],["me?"].

modalverb(1) --> ["can"].
modalverb(2) --> ["could"].
modalverb(3) --> ["might"].

chatbot(1) --> ["you"].
chatbot(2) --> ["you,","please,"].
chatbot(2) --> ["the"], ["chatbot"].
chatbot(4) --> ["the"], ["chatbot,"], ["please,"].


% offerhelp
type("offerhelp") -->
    {draw(2,R), draw(3,T)}, accepting(R), asking(T).

accepting(1) --> ["of"],["course!"].
accepting(2) --> ["yes!"].

asking(1) --> {draw(2,r)}, ["in"], ["what"], a(r), ["need"], ["help?"].
asking(2) --> ["where"], ["can"], ["i"], ["be"], ["useful?"].
asking(3) --> {draw(2,r)}, ["just"], ["tell"], ["me"], ["what"], b(r), ["to"], ["know."].

a(1) --> ["do"], ["you"].
a(2) --> ["does"], ["the"], ["human"].

b(1) --> ["the"], ["human"], ["needs"].
b(2) --> ["you"], ["need"].


% proposeanswerquestion
type("proposeanswerquestion") -->
    ["What"],["does"],["the"],["append"],["predicate"],["do?"].


% goodbye
type("goodbye") --> {draw(2,R)},who(R).

who(1) --> {draw(3,R), draw(3,T)}, c(R), d(T).
who(2) --> {draw(3,R)}, e(R).

c(1) --> ["i'm"],["sorry"],["but"],["i"],["need"],["to"],["go..."].
c(2) --> ["i'm"],["in"],["a"],["hurry..."],["i'm"],["sorry"].
c(3) --> ["i"], ["don't"], ["have"], ["more"], ["questions..."].

d(1) --> ["thanks"], ["for"], ["the"], ["help!"].
d(2) --> ["bye."].
d(3) --> ["you"], ["did"], ["a"], ["great"], ["job!"], ["bye."].

e(1) --> ["it"], ["was"], ["a"], ["pleasure"], ["to"], ["help"], ["you!"].
e(2) --> ["thankful"], ["for"], ["helping"], ["you!"].
e(3) --> ["bye!"], ["hope"], ["to"], ["see"], ["you"], ["soon."].
    


% auxiliar predicates
nats(0,[]).
nats(N,[N|Xs]) :-
    not(compare(<,N,1)),
    X is N-1,
    nats(X,Xs).

draw(N,R) :-
    nats(N,A), random_permutation(A,B),!, member(R,B).
