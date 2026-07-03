% a) colocar_pieza(Pieza1,Pieza2,?Resultado) ← Resultado es el resultado de colocar la
% Pieza2 sobre la Pieza1, comenzando en el primer lugar vacío de Pieza1. Por ejemplo:
% colocar_pieza([a,_,_],[b],[a,b,_]).
% colocar_pieza([c],[b,_,a,_],[c,b,_,a,_]).

colocar_pieza([],P2,P2).
colocar_pieza([P|P1s],P2,Resultado) :- 
    nonvar(P),
    colocar_pieza_rec(P1s,P2,[P|Resultado]).
colocar_pieza([P|P1s],P2,Resultado) :- 
    var(P),
    merge_piezas([P|P1s],P2,Resultado).

merge_pieza([],P,P).
merge_pieza(P,[],P).
merge_piezas([P|P1s],[P|P2s],[P|Resultado]) :- 
    merge_piezas(P1s,P2s,Resultado).

% b) resolver_puzzle(+Piezas,?Solucion) ← Solucion es una solución al puzzle formado por
% Piezas. Por ejemplo:
% resolver_puzzle(Piezas1,[u,n,i,d,i,m,e,n,s,i,o,n,a,l]).

resolver_puzzle(Piezas,Solucion) :-
    select(P,Pieza,Resto),
    resolver_puzzle(Resto,SolucionParcial),
    colocar_pieza(P,SolucionParcial,Resultado).

% puzzle_bien_formado(+Piezas) ← Piezas representa un puzzle bien formado, esto
% significa que para el conjunto de piezas existe una sola solución. Por ejemplo:

puzzle_bien_formado(Piezas) :-
    findall(S, resolver_puzzle(Piezas,S),R),
    length(S,1).