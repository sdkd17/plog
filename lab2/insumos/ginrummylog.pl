% Representacion de Carta
% Carta: c(Valor, Palo).
%         Palo in {c, d, t, p} (corazón, diamante, trébol, pica) 
%         Valor in {a,2,3,4,5,6,7,8,9,10,j,q,k}

% ####################################################################################
% is_meld(+Cartas) -  Se cumple si y solo si Cartas es un set o un run válido
% Ejemplos
%   is_meld([c(2,c), c(a,c), c(3,c)]) → true (run)
%   is_meld([c(a,c), c(a,d), c(a,t)]) → true (set de tres).
%   is_meld([c(a,d), c(3,t), c(4,t)]) → false.
is_meld(Cartas) :- is_set(Cartas).
is_meld(Cartas) :- is_run(Cartas).


% is_set(+Cartas) - Se cumple si Cartas es un set valido (tres o cuatro cartas del mismo valor y palos distintos)
% Ejemplos
%   is_set([c(a,c), c(a,d), c(a,t)]) → true (set de tres)
%   is_set([c(a,d), c(3,t), c(4,t)]) → false.

is_set([C|Cs]) :- is_set_rec(Cs,C,1).

is_set_rec([C1|Cs],C,Length) :- 
    igual_valor(C1,C),
    L1 is Length + 1,
    is_set_rec(Cs,C,L1).
is_set_rec([],_,L) :- L > 2, L < 5.

% igual_valor(+Carta1, +Carta2) - Se cumple si valor de carta 1 es igual al valor de carta 2
igual_valor(c(V,P1), c(V,P2)) :- P1 \= P2.

% is_run(+Cartas) - Se cumple si Cartas es un run valido (tres o más cartas siguiente en valor y del mismo palo)

is_run(Cartas) :- 
    select_min(Cartas, Min, CartasSinMin),
    is_run_rec(CartasSinMin, Min, 1).

is_run_rec(Cartas, Min, Length) :-
    select_min(Cartas, Min1, CartasSinMin),
    siguiente(Min,Min1), % poner un cut aca? Una vez que encuentra uno en siguiente no tiene sentido explorar resto de las reglas
    L1 is Length + 1,
    is_run_rec(CartasSinMin, Min1, L1).
is_run_rec([],_,L) :- L > 2.

% select_min(+Cartas, ?Min, ?R) - Se cumple si Min es la carta minima de Cartas y R es Cartas sin Min (asume todas las cartas del mismo Palo)  
select_min(Cartas, Min, R) :- 
    minL(Cartas, c(k,_), Min),
    select(Min, Cartas, R). % 

% minL(+Cartas,+MinAcc,?M) - M es la carta menor de la lista Cartas (asume todas las cartas del mismo Palo)  
minL([H|T],Min,M) :- 
    min(H,Min,Min1),!, % una vez que encuentra un minimo, no busca en el resto de las opciones
    minL(T,Min1,M).
minL([],X,X).

% min(+C1,+C2,C) - se cumple si C es la carta de menor valor entre C1 y C2, y C1 y C2 son del mismo palo
min(c(_,P),c(a,P),c(a,P)).
min(c(a,P),c(_,P),c(a,P)).
min(c(A,P),c(B,P),c(A,P)) :- integer(A), integer(B), A =< B.
min(c(A,P),c(B,P),c(B,P)) :- integer(A), integer(B), A > B.
min(c(A,P),c(j,P),c(A,P)) :- integer(A).
min(c(j,P),c(A,P),c(A,P)) :- integer(A).
min(c(A,P),c(q,P),c(A,P)) :- integer(A).
min(c(q,P),c(A,P),c(A,P)) :- integer(A).
min(c(A,P),c(k,P),c(A,P)) :- integer(A).
min(c(k,P),c(A,P),c(A,P)) :- integer(A).
min(c(j,P),c(q,P),c(j,P)).
min(c(q,P),c(j,P),c(j,P)).
min(c(j,P),c(k,P),c(j,P)).
min(c(k,P),c(j,P),c(j,P)).
min(c(q,P),c(k,P),c(q,P)).
min(c(k,P),c(q,P),c(q,P)).

% siguiente(+Carta1, +Carta2) - Se cumple si Carta2 es siguiente a Carta1 (Mismo Palo, valor consecutivo)
siguiente(c(V1,P), c(V2,P)) :-
    integer(V1),
    integer(V2),
    V2 is V1 + 1.

siguiente(c(a,P), c(2,P)).
siguiente(c(9,P), c(j,P)).
siguiente(c(j,P), c(q,P)).
siguiente(c(q,P), c(k,P)).

% ####################################################################################
% Las cartas de la mano que no se asignan a ningún meld en una descomposición dada forman el deadwood relativo a esa descomposición. 
% Su valor es la suma de:
%   As:1
%   2–10: su número
%   J,Q,K:10cadauna

% valor_deadwood(+Cartas, ?Valor) - Valor es la suma de valores de puntos de las cartas en Cartas según la tabla de deadwood.
valor_deadwood(Cartas, Valor) :- acc(Cartas,suma,0,Valor).

% acc(+Cartas, +Predicado, +Acumulador, ?Valor) - Valor es el resultado de aplicar el predicado a los elementos de Cartas, se va acumulando el resultado en Acumulador 
acc([],_,Acc,Acc).
acc([C|Cs],Op,Acc,Valor) :-
    valor(C, Vc),!,
    T =.. [Op,Vc,Acc,Acc1],
    T,
    acc(Cs,Op,Acc1,Valor).

suma(X,Y,Z) :- Z is X+Y.

%valor(+Carta, ?Valor) - se cumple si valor es el valor entero de Carta
valor(c(a,_),1).
valor(c(A,_),A) :- integer(A).
valor(c(j,_),10).
valor(c(q,_),10).
valor(c(k,_),10).
% ####################################################################################

% get_melds(+Mano, ?Melds, ?Sobrantes): Melds es una lista de listas; cada sublista
% es un meld válido. Este predicado puede ser no determinista: una misma mano
% puede admitir varias descomposiciones. En ningún caso importa el orden de las
% listas. Observar que este predicado genera todas las descomposiciones, la que
% minimiza el valor del deadwood y las que no.
get_melds(Mano, Melds, Sobrantes) :-
    % generar subconjuntos de Mano con largo mayor a 2
    particion(Mano, P),
    filter_is_meld(P, Melds, []).
    
   
filter_is_meld([P|Ps],Melds,Acc) :-
    is_meld(P),
    filter_is_meld(Ps,Melds,[P|Acc]).

filter_is_meld([P|Ps],Melds,Acc) :-
    \+ is_meld(P),
    filter_is_meld(Ps,Melds,Acc).

filter_is_meld([],Acc,Acc).

% particion(+L,?P) - se cumple si P es una particion de L
particion([L|Ls], P) :-
    particion(Ls,Resto),
    dos_opciones(L,Resto,P).
particion([X],[[X]]).   

dos_opciones(L,Resto,[[L]|Resto]).
dos_opciones(L,Resto,P) :- 
    select(Ri,Resto,R1),
    append([[L|Ri]],R1,P).

% validar_particion(+P,+AccM,+Accs,?Melds,?Sobrantes) - 
% validarParticion(P,Melds,Sobrantes) :-
%     select(Meld,P,Pr),
%     validarParticion(Pr,Melds,Sobrantes).


% ####################################################################################
% best_melds(+Mano, ?MejorMelds, ?Sobrante, ?Valor)

% ####################################################################################
% robar(+Mano, +Descarte, +CartasVistas, +Estrategia, ?Lugar)

% ####################################################################################
% descartar(+OldMano, +CartasVistas, +Estrategia, ?NewMano, ?NewDescarte)

% ####################################################################################
% cerrar(+Mano, +CartasVistas, +Estrategia, ?Decision)