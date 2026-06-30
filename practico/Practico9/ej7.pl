% a) Defina una gramatica DCG para el lenguaje sobre el alfabeto {a,b} cuyas tiras son de la forma ww, w in {a,b}*
s --> s1(L),s1(L).
s1([]) --> [].
s1([[a]|Xs]) --> [a],s1(Xs).
s1([[b]|Xs]) --> [b],s1(Xs).

% b) Construya una gramatica DCG que reconozca el lenguaje L = {y,w in (a|b)* / x = yww^Ry}
% aba abb bba aba

r --> s1(L),r1,s1(L).
r1 --> [].
r1 --> [a],r1,[a].
r1 --> [b],r1,[b].

