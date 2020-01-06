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
	
	"
-------------------------------------------------------------------------------------------------------

chat_at_aim(S1,S2,L,SearchProcedure) --> Este predicado gera uma conversa de tamanho L, no máximo, a começar na frase S1 e a terminar na frase S2, utilizando como método de pesquisa SearchProcedure.

Por exemplo: 
	chat_at_aim(,,,) gera a conversa:
	"
	"