
% % inserta X en cada una de las listas de LL
% insert_x(_,[],[]).
% insert_x(X,[L|Ls],[[X|L]|Rs]) :- insert_x(X,Ls,Rs).


% % subconjuntos(+L, ?S, ?R) - se cumple si S es un subconjunto de L y R es L - S
% subconjuntos([],[],[]).
% subconjuntos([L|Ls], [L|Cs],R) :- subconjuntos(Ls,Cs,R).
% subconjuntos([L|Ls], Cs, [L|R]) :- subconjuntos(Ls,Cs,R).

% subset([],[]).
% subset([L|Ls], [L|Cs]) :- subset(Ls,Cs).
% subset([_|Ls], Cs) :- subset(Ls,Cs).


% % subconjuntos_n(+L,+N,?S) - se cumple si S es un subconjunto de L y largo de S es mayor que N
% subset_melds(L,N,S) :-
%   subset(L,S),
%   length(S,N1), N1 > N,
%   is_meld(S).


