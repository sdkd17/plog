% a) Considere un escenario donde existe una moneda desbalanceada (la probabilidad de que
% salga Cara es de un 40%), y dos urnas con bolas: en la primera, hay 70 bolas rojas y 30
% azules, mientras que en la segunda hay 50 bolas azules, 30 rojas y 20 negras. Un jugador
% lanza la moneda y saca una bola al azar de cada una de las urnas, y gana si la moneda sale
% cara y al menos una bola es azul, o si las dos bolas son del mismo color.
% Construya un programa en Problog que permita saber la probabilidad de ganar el juego.

% 0,4::moneda(cara).

% 0,3::urna(1,azul).
% 0,7::urna(1,rojo).

% 0,5::urna(2,azul).
% 0,3::urna(2,rojo).
% 0,2::urna(2,negro).

% ganar :- moneda(cara),urna(1,azul), urna(2,roja).
% ganar :- moneda(cara),urna(2,azul), urna(2,roja).
% ganar :- moneda(cara),urna(2,azul), urna(2,negra).
% ganar :- moneda(numero),urna(1,azul), urna(2,azul).

% query(ganar).

% b) Utilizando DCG, define un programa Prolog para reconocer el siguiente lenguaje:
% L = {a^n b^mc^m+n d^m*n / n,m ≥ 0}
ss(_,0) --> [].
ss(A,N) --> [A],ss(A,N1), {N is N1 + 1}. 

s(N,M) --> ss(a,N),ss(b,M),ss(c,N1),ss(d,M1),{N1 is N + M, M1 is N*M}.