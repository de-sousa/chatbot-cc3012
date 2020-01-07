AVISO: É necessário carregar todos os ficheiros presentes para funcionar!

sentence_type(S,T) --> Classifica uma frase (dada por uma lista) num determinado tipo, de acordo com o conteúdo da frase. 
Por exemplo: 
	sentence_type(["Thanks","for","the","help!"],T), T unifica com "goodbye".

É, também, capaz de generar frases de determinado tipo.
Por exemplo: 
	sentence_type(S,"askhelp"), S vai unificar com todas as possibilidades de frases do tipo "askhelp".

Para se obter todos os pares possíveis, (S,T): sentence_type(S,T).

Tipos disponíveis: "greetings", "askhelp", "offerhelp", "goodbye", "rushedgoodbye".
-------------------------------------------------------------------------------------------------------

semtrans(LT,T,P) --> Determina a probabilidade P de ir de uma lista de tipos LT (no máximo,2), para um tipo T.
Por exemplo: 
	semtrans([],"greetings",P), P unifica com 0.99. 
	semtrans(["askhelp","greetings"],"offerhelp",P), P unifica com 0.80.

-------------------------------------------------------------------------------------------------------

chataway(L) --> Gera conversas, plausíveis, de tamanho L, no máximo. A chamada com o mesmo argumento, gera (possivelmente) diferentes conversas.

Por exemplo:
	chataway(5) gera a conversa: 
	"
	?- chataway(5).
	- Hello, friend! Hope you are having a good day!
	- Might you, please, help me?
	- Of course! In what does the human need help?
	- What does the prefix predicate do?
	- I don't have more time... Anyway, thank you!
	true.

	?- chataway(5).
	- Hello, chatbot! Hope you are having a good day!
	- Hi, chatbot! It feels like I don't see you for years!
	- Could you, please, help me?
	- Yes! Where can i be useful?	
	- I'm in a hurry... I'm sorry
	true.

-------------------------------------------------------------------------------------------------------

chat_at_aim(S1,S2,L,SearchProcedure) --> Este predicado gera uma conversa de tamanho L, no máximo, a começar na frase S1 e a terminar na frase S2, utilizando como método de pesquisa SearchProcedure.

Por exemplo: 
	chat_at_aim/3 gera a conversa:
	"
	?- sentence_type(A,"greetings"), sentence_type(B,"goodbye"), chat_at_aim(A,B,10,dfs).
	- Could you help me?
	- Of course! In what do you need help?
	- What does the append predicate do?
	- append(L1,L2,L3) L3 is the result of the concatenation of L1 and L2.
	- Thank you! I didn't use it for a long time, that I forgot.
	A = ["Hello,", "chatbot!", "It", "feels", "like", "I", "don't", "see", "you"|...],
	B = ["Thankful", "for", "helping", "you!"] .
	"
e:
	"
	?- sentence_type(A,"greetings"), sentence_type(B,"goodbye"), chat_at_aim(A,B,5,bfs).
	- Can you help me?
	- Of course! Just tell me what you need to know.
	- What does the append predicate do?
	- append(L1,L2,L3) L3 is the result of the concatenation of L1 and L2.
	- Oh, thank you!
	A = ["Hello,", "chatbot!", "It's", "nice", "too", "see", "you", "again!"],
	B = ["I", "don't", "have", "more", "questions...", "Thank", "you!"] .
	"
Apenas estão definidos o dfs e o bfs.
