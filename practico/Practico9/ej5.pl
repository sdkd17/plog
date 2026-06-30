% Utilizando DCG (Gramaticas de Prolog), defina programas para reconocer los lenguajes:
% a) L = {a*b*c*}
s --> a,b,c.
a --> [].
a --> [a],a.
b --> [].
b --> [b],b.
c --> [].
c --> [c],c.

% b) L = {a^nb^n/ n>=0}
s_b --> [].
s_b --> [a],s_b,[b].

% c) L = {ww^R / w in {a,b}* }
s_c --> [].
s_c --> [a],s_c,[a].
s_c --> [b],s_c,[b].

% d) L = {a^nb^nc^n / n>= 0}
s_d --> a_d(N),b_d(N),c_d(N).
a_d(0) --> [].
a_d(N) --> [a],a_d(N1),{N is N1 + 1}.
b_d(0) --> [].
b_d(N) --> [b],b_d(N1),{N is N1 + 1}.
c_d(0) --> [].
c_d(N) --> [c],c_d(N1),{N is N1 + 1}.

% e) L = {x^ny^mz^n+m / n,m >= 0 }
s_e --> [].
s_e --> [x],s_e,[z].
s_e --> y.
y --> [].
y --> [y],y,[z].

