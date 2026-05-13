
%subconjunto(+L,+C) - se cumple si C es un subconjunto de L
% subconjunto(L,[C|Cs]) :-
%   select(C,L,L1),
%   subconjunto(L1,Cs).
% subconjunto(_,[]).

subconjuntos([],[]).
subconjuntos([L|Ls], [L|Cs]) :- subconjuntos(Ls,Cs).
subconjuntos([_|Ls], Cs) :- subconjuntos(Ls,Cs).

subconjuntos_n(L,N,S) :-
  subconjuntos(L,S),
  length(S,N1), N1 > N.




