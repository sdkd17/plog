% Evaluacion 2025 - Ejercicio 4
% Escribir gramatica logica que reconozca expresiones aritmeticas simples. 
% Expresiones posibles:
% - numero: digito del 0 al 9 o digito negado
% - operador binario aplicado a dos numeros
% los operadores binarions son : [mas, menos, por,dividido], operador de negacion es neg.

exp --> z.
exp --> op.

z --> num.
z --> u_op,num.

op --> z,bin_op,z.

num --> [0].
num --> [1].
num --> [2].
num --> [3].
num --> [4].
num --> [5].
num --> [6].
num --> [7].
num --> [8].
num --> [9].

bin_op --> [mas].
bin_op --> [menos].
bin_op --> [por].
bin_op --> [dividido].

u_op --> [neg].

% Escriba una gramatica logica que reconozca las expresiones de la parte a 
% y las evalue. Asumir definidos los predicados de las operadores
% Ej: ?- s(Res, [1,mas,2],[])
%   Res = 3.
% usar =.. y call para crer y invocar predicados

s(Res) --> exp(Res).

exp(Res) --> z(Res).
exp(Res) --> oper(Res).

z(Res) --> num(Res).
z(Res) --> u_op(UOp),num(N), {T =.. [UOp,N,Res], call(T)}.

oper(Res) --> z(N1),bin_op(BinOp),z(N2), {T =..[BinOp,N1,N2,Res],call(T)}.

num(0) --> [0].
num(1) --> [1].
num(2) --> [2].
num(3) --> [3].
num(4) --> [4].
num(5) --> [5].
num(6) --> [6].
num(7) --> [7].
num(8) --> [8].
num(9) --> [9].

bin_op(suma) --> [mas].
bin_op(diferencia) --> [menos].
bin_op(producto) --> [por].
bin_op(cociente) --> [dividido].

u_op(negativo) --> [neg].


suma(N1,N2,N3) :- N3 is N1 + N2.
diferencia(N1,N2,N3) :- N3 is N1 - N2.
producto(N1,N2,N3) :- N3 is N1 * N2.
cociente(N1,N2,N3) :- N3 is N1 / N2.
negativo(N1,N2) :- N2 is -N1.

