% sentence_type(L,T)
% sentence_type generates/classifies a sentence S from/to a given type T
sentence_type(S,T):-
   type(T,S,[]).

% greetings
type("greetings") -->  {draw(2,R),draw(3,T),draw(5,U)}, hi(R),to(T),extend(U).

hi(1) --> ["Hi,"].
hi(2) --> ["Hello,"].

to(1) --> ["chatbot!"].
to(2) --> ["dear"], ["friend."].
to(3) --> ["friend!"].

extend(N) --> {0 is N mod 2}, [].
extend(1) --> ["Hope"],["you"],["are"] ,["having"], ["a"] ,["good"] ,["day!"].
extend(3) --> ["It's"], ["nice"], ["too"], ["see"], ["you"], ["again!"].
extend(5) --> ["It"],["feels"],["like"],["I"],["don't"],["see"],["you"],["for"],["years!"].


% askhelp
type("askhelp") --> {draw(3,R),draw(4,T)}, modalverb(R),chatbot(T),["help"],["me?"].

modalverb(1) --> ["Can"].
modalverb(2) --> ["Could"].
modalverb(3) --> ["Might"].

chatbot(1) --> ["you"].
chatbot(2) --> ["you,","please,"].
chatbot(2) --> ["the"], ["chatbot"].
chatbot(4) --> ["the"], ["chatbot,"], ["please,"].


% offerhelp
type("offerhelp") -->
    {draw(2,R), draw(3,T)}, accepting(R), asking(T).

accepting(1) --> ["Of"],["course!"].
accepting(2) --> ["Yes!"].

asking(1) --> {draw(2,R)}, ["In"], ["what"], a(R), ["need"], ["help?"].
asking(2) --> ["Where"], ["can"], ["i"], ["be"], ["useful?"].
asking(3) --> {draw(2,R)}, ["Just"], ["tell"], ["me"], ["what"], b(R), ["to"], ["know."].

a(1) --> ["do"], ["you"].
a(2) --> ["does"], ["the"], ["human"].

b(1) --> ["the"], ["human"], ["needs"].
b(2) --> ["you"], ["need"].

% question
type("q1") --> ["What does the"],["append"],["predicate do?"].
type("q2") --> ["What does the"],["sort"],["predicate do?"].
type("q3") --> ["What does the"],["member"],["predicate do?"].
type("q4") --> ["What does the"],["select"],["predicate do?"].
type("q5") --> ["What does the"],["prefix"],["predicate do?"].
type("q6") --> ["What does the"],["nth0"],["predicate do?"].

% answer
type("a1") --> ["append(L1,L2,L3)"], ["L3"],["is"],["the"],["result"],["of"],["the"],["concatenation"],["of"],["L1"],["and"],["L2."].
type("a2") --> ["sort(L1,L2)"], ["L2"], ["is"], ["the"], ["result"], ["of"], ["sorting"], ["the"], ["list"], ["L1"],["by"],["the"],["natural"], ["order"],["of"],["the"],["elements."].
type("a3") --> ["member(X,L)"], ["is"], ["true"], ["if"], ["X"],["is"],["an"],["element"],["of"],["L."].
type("a4") --> ["select(X,L1,L2)"], ["is"], ["true"], ["if"], ["L2"],["is"],["the"],["list"],["L1"],["without"],["the"],["X."].
type("a5") --> ["prefix(Part,Whole"], ["is"], ["true"],["if"],["Part"],["is"],["a"],["leading"],["substring"],["of"],["Whole."].
type("a6") --> ["nth0(Id,L,X)"],["is"],["true"],["if"],["the"],["element"],["X"],["is"],["Id'th"],["element"],["of"],["the"],["list."],["Counting"],["starts"],["at"],["zero."].




% thanks
type("thanks") --> {draw(3,R)}, t(R).
t(1) --> ["Oh,"],["thank"],["you!"].
t(2) --> ["Thank"],["you!"],["I"],["didn't"],["use"],["it"],["for"],["a"],["long"],["time,"],["that"],["I"],["forgot."].
t(3) --> ["Oh,"],["you"],["got"],["me,"],["once"],["again!"],["Thanks."].

% goodbye
type("goodbye") --> {draw(2,R)}, who(R).

who(1) --> {draw(4,R)}, c(R).
who(2) --> {draw(3,R)}, d(R).

c(1) --> ["Thanks"], ["for"], ["the"], ["help!"].
c(2) --> ["Bye."].
c(3) --> ["You"], ["did"], ["a"], ["great"], ["job!"], ["bye."].
c(4) --> ["I"], ["don't"], ["have"], ["more"], ["questions..."], ["Thank"],["you!"].

d(1) --> ["It"], ["was"], ["a"], ["pleasure"], ["to"], ["help"], ["you!"].
d(2) --> ["Thankful"], ["for"], ["helping"], ["you!"].
d(3) --> ["Bye!"], ["Hope"], ["to"], ["see"], ["you"], ["soon."].

% rushedgoodbye
type("rushedgoodbye") --> {draw(4,R)}, e(R).

e(1) --> ["I'm"],["sorry"],["but"],["I"],["need"],["to"],["go..."].
e(2) --> ["I'm"],["in"],["a"],["hurry..."],["I'm"],["sorry"].
e(3) --> ["I"], ["don't"], ["have"], ["more"], ["time..."], ["Anyway,"],["thank"],["you!"].
e(4) --> ["Someone"],["is"],["calling"],["me..."],["It"],["was"],["a"],["pleasure"],["talking"],["to"],["you!"].

