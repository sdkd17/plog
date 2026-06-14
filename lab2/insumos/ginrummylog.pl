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

% igual_palo(+Carta1, +Carta2) - Se cumple si palo de carta 1 es igual al palo de carta 2
igual_palo(c(_,P), c(_,P)).


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
min(c(_,_),c(a,P),c(a,P)).
min(c(a,P),c(_,_),c(a,P)).
min(c(A,P),c(B,_),c(A,P)) :- integer(A), integer(B), A =< B.
min(c(A,_),c(B,P),c(B,P)) :- integer(A), integer(B), A > B.
min(c(A,P),c(j,_),c(A,P)) :- integer(A).
min(c(j,_),c(A,P),c(A,P)) :- integer(A).
min(c(A,P),c(q,_),c(A,P)) :- integer(A).
min(c(q,_),c(A,P),c(A,P)) :- integer(A).
min(c(A,P),c(k,_),c(A,P)) :- integer(A).
min(c(k,_),c(A,P),c(A,P)) :- integer(A).
min(c(j,P),c(q,_),c(j,P)).
min(c(q,_),c(j,P),c(j,P)).
min(c(j,P),c(k,_),c(j,P)).
min(c(k,_),c(j,P),c(j,P)).
min(c(q,P),c(k,_),c(q,P)).
min(c(k,_),c(q,P),c(q,P)).

max(c(A,P),c(a,_),c(A,P)).
max(c(a,_),c(A,P),c(A,P)).
max(c(A,P),c(B,_),c(A,P)) :- integer(A), integer(B), A >= B.
max(c(A,_),c(B,P),c(B,P)) :- integer(A), integer(B), A < B.
max(c(A,_),c(j,P),c(j,P)) :- integer(A).
max(c(j,P),c(A,_),c(j,P)) :- integer(A).
max(c(A,_),c(q,P),c(q,P)) :- integer(A).
max(c(q,P),c(A,_),c(q,P)) :- integer(A).
max(c(_,_),c(k,P),c(k,P)).
max(c(k,P),c(_,_),c(k,P)).
max(c(j,_),c(q,P),c(q,P)).
max(c(q,P),c(j,_),c(q,P)).
max(c(A,P),c(A,_),c(A,P)).

% siguiente(+Carta1, +Carta2) - Se cumple si Carta2 es siguiente a Carta1 (Mismo Palo, valor consecutivo)
siguiente(c(V1,P), c(V2,P)) :-
    integer(V1),
    integer(V2),
    V2 is V1 + 1.

siguiente(c(a,P), c(2,P)).
siguiente(c(10,P), c(j,P)).
siguiente(c(j,P), c(q,P)).
siguiente(c(q,P), c(k,P)).

anterior(c(V1,P), c(V2,P)) :-
    integer(V1),
    integer(V2),
    V1 is V2 + 1.

anterior(c(2,P), c(a,P)).
anterior(c(j,P), c(10,P)).
anterior(c(q,P), c(j,P)).
anterior(c(k,P), c(q,P)).


% ####################################################################################
% Las cartas de la mano que no se asignan a ningún meld en una descomposición dada forman el deadwood relativo a esa descomposición. 
% Su valor es la suma de:
%   As:1
%   2–10: su número
%   J,Q,K:10cadauna

% valor_deadwood(+Cartas, ?Valor) - Valor es la suma de valores de puntos de las cartas en Cartas según la tabla de deadwood.
valor_deadwood(Cartas, Valor) :- suma_valores(Cartas,0,Valor).

suma_valores([C|Cs],Acc,Valor) :-
    valor(C,Vc),
    Acc1 is Vc + Acc,
    suma_valores(Cs,Acc1,Valor).
suma_valores([],Acc,Acc).

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
    % generar subconjuntos de Mano  
    particion(Mano, P),
    filter_melds(P, Melds,SobrantesSet, is_meld),
    flatten(SobrantesSet,Sobrantes).

filter_melds([P|Ps], Melds,Sobrantes,Predicado) :- filtrar(P,Ps,Melds,Sobrantes,Predicado).
filter_melds([],[],[],_).

filtrar(P,Ps,[P|Melds],Sobrantes,Predicado) :-
    T =.. [Predicado,P],
    T,!,
    % is_meld(P),!,
    filter_melds(Ps,Melds,Sobrantes,Predicado).

filtrar(P,Ps,Melds,[P|Sobrantes], Predicado) :-
    filter_melds(Ps,Melds,Sobrantes,Predicado).

% particion(+L,?P) - se cumple si P es una particion de L agrupando por numero de carta o por palo
particion([L|Ls], P) :-
    particion(Ls,Prec),
    tres_opciones(L,Prec,P).
particion([],[]).

% tres_opciones(+L,+Particion,?NuevaParticion) - NuevaParticion es la particion P agregando el elemento L
% Agrega a L como:
%    - un nuevo conjunto
%    - Lo agrega a un conjunto de P que contenga una carta del mismo palo que L
%    - Lo agrega a un conjunto de P que contenga una carta del mismo valor
tres_opciones(L,Particion,[[L]|Particion]).

tres_opciones(L,Particion,P) :- 
    select_mismo_numero(L,Pi,Particion,R),
    append([[L|Pi]],R,P).

tres_opciones(L,Particion,P) :- 
    select_mismo_palo(L,Pi,Particion,R),
    append([[L|Pi]],R,P).

% select_mismo_numero(+C,?P,?Particion,?R) - selecciona en P un elemento de Particion que contiene 
% una carta del mismo valor que C. R es Particion - {P}
select_mismo_numero(C,[Ci|Pi],Particion,R) :-
    select([Ci|Pi],Particion,R),
    igual_valor(C,Ci).

% select_mismo_numero(+C,?P,?Particion,?R) - selecciona en P un elemento de Particion que contiene 
% una carta del mismo palo que C. R es Particion - {P}
select_mismo_palo(C,[Ci|Pi],Particion,R) :-
    select([Ci|Pi],Particion,R),
    igual_palo(C,Ci).

% ####################################################################################
% best_melds(+Mano, ?MejorMelds, ?Sobrante, ?Valor) - De todas las particiones
% que pueden obtenerse via get_melds nos quedamos con la que minimiza el valor del 
% deadwood. Si hay varias particiones que minimizan este valor puede devolverse 
% cualquiera de ellas. Tiene la restricción de que MejorMelds no puede 
% tener más de 10 cartas.

best_melds(Mano,MejorMelds,Sobrante,Valor) :- 
    % format('Mano => ~w~n',[Mano]),
    findall((M,S), get_melds(Mano,M,S),Melds),
    best_melds_rec(Melds,MejorMelds,Sobrante,Valor,[],[],110).

best_melds_rec([(M,S)|Melds],MejorMelds,Sobrante,Valor,BestMeld,Leftovers,Min) :-
    valor_deadwood(S,V),
    % write(M), write('-'), write(S), write('=>'), write(V), write('\n'), 
    minMeld(M,S,V,BestMeld,Leftovers,Min,Mnuevo,Snuevo,MinNuevo),
    best_melds_rec(Melds,MejorMelds,Sobrante,Valor,Mnuevo,Snuevo,MinNuevo).
best_melds_rec([],M,S,V,M,S,V).

% minMeld(+M1,+S1,+V1,+M2,+S2,+V2,?R1,?R2,?R3) - Se cumple si R es el minimo entre M1 y M2 en valor
minMeld(M1,S1,V1,_,_,V2,M1,S1,V1) :- V1 < V2. 
minMeld(_,_,V1,M2,S2,V2,M2,S2,V2) :- V1 >= V2. 

% ####################################################################################
% robar(+Mano, +Descarte, +CartasVistas, +Estrategia, ?Lugar)
% Este predicado decide de donde vamos a robar la carta. Descarte: carta en el tope del 
% descarte (término c/2). CartasVistas: lista de cartas vistas según la definición de 
% arriba. Estrategia ∈ {random, greedy, pro}. Lugar ∈ {mazo, descarte}.

% Estrategia RANDOM
robar(_,_,_,random,Lugar) :- random_between(0,1,R),robar_random(R,Lugar).

% Estrategia GREEDY 
% ¿Cual es la opcion localmente optima para robar en cada mano?
% selecciono el tope del descarte si no aumenta el deadwood
robar(Mano,Descarte,_,greedy,Lugar) :-
    best_melds(Mano,_,_,DeadwoodMano),
    % format('DeadwoodMano = ~w~n', [DeadwoodMano]),
    best_melds([Descarte|Mano],_,_,DeadwoodDescarte),
    % format('DeadwoodDescarte = ~w~n', [DeadwoodDescarte]),
    robar_greedy(DeadwoodMano,DeadwoodDescarte,Lugar),!.

% Estrategia PRO
% Cual seria una mejor estrategia que greedy para robar?
% Igual que greedy, si la carta del descarte forma un meld, robo del descarte.
% Luego, si la carta del descarte es siguiente o si es el mismo numero que alguna de las sobrantes la robo, si no robo del mazo 
% Ademas tener en cuenta que si la que falta para formar un meld esta en cartas vistas no la deberia robar del descarte.
robar(Mano,Descarte,CartasVistas,pro,descarte) :-
    robar(Mano, Descarte, CartasVistas,greedy,descarte),!.

% robar(Mano,Descarte,CartasVistas,pro,descarte) :-
%     best_melds(Mano,_,Sobrantes,_),
%     select(Carta, Sobrantes,_),
%     futuro_meld(Descarte, Carta, CartasVistas),!.

% Aca ya se que Descarte no es parte de los melds
% Busco proyectos de meld, si Descarte es menor que sobranteSobrantes mas grande, elijo la del descarte
robar(Mano,Descarte,CartasVistas,pro,descarte) :-
    best_melds(Mano,_,Sobrantes,_),
    best_melds_sobrantes(Sobrantes, _, SobrantesSobrantes),
    \+ es_igual_valor_unico_sobrante(Descarte,SobrantesSobrantes),
    robar_pro_descarte(Descarte,Sobrantes,CartasVistas,SobrantesSobrantes),!.

robar(_,_,_,pro,mazo).

% La sobrante no forma parte de los melds, tengo que robar del mazo si el descarte es igual valor
es_igual_valor_unico_sobrante(Descarte,Sobrantes) :-
    format('Sobrantes: ~w~n', [Sobrantes]),
    select(S,Sobrantes,[]),
    igual_valor(S,Descarte),!.

%Si el descarte mas una de las sobras puede formar un meld
robar_pro_descarte(Descarte,Sobrantes,CartasVistas,_) :-
    select(Carta, Sobrantes,_),
    futuro_meld(Descarte, Carta, CartasVistas),%!.
    format('Futuro Meld ~w~n', [[Descarte,Carta]]),!.

% si el descarte no puede formar un meld, pero es menor que la mayor de las sobras, elijo descarte
robar_pro_descarte(Descarte,_,_,SobrantesSobrantes) :-
    maxL(SobrantesSobrantes,c(a,_),Max),
    min(Descarte,Max,Descarte),!.



% futuro_meld(+Carta1,+Carta2) - Se cumple si Carta1 y carta 2 son siguentes o son el mismo numero y la carta restante para 
% formar el meld no esta en cartas vistas. Estas cartas podrian formar un meld.
futuro_meld(Carta1, Carta2,CartasVistas) :- siguiente(Carta1,Carta2), \+ completar_run(Carta1,Carta2,CartasVistas).
futuro_meld(Carta1, Carta2,CartasVistas) :- siguiente(Carta2,Carta1), \+ completar_run(Carta1,Carta2,CartasVistas).
futuro_meld(Carta1, Carta2,CartasVistas) :- igual_valor(Carta1,Carta2), \+ completar_set(Carta1,Carta2,CartasVistas).

% completar_meld(+Carta1,Carta2,CartasVistas) - se cumple si existe una carta en cartas vistas que completa un meld con carta1 y carta2
% completar_meld(Carta1,Carta2,CartasVistas) :- completar_run(Carta1,Carta2,CartasVistas).
% completar_meld(Carta1,Carta2,CartasVistas) :- completar_set(Carta1,Carta2,CartasVistas).

completar_run(Carta1,Carta2,CartasVistas) :-
    select(Carta3,CartasVistas,_),
    is_run([Carta1,Carta2,Carta3]),!.

completar_set(Carta1,Carta2,CartasVistas) :-
    select(Carta3,CartasVistas,Resto),
    select(Carta4,Resto,_),
    is_set([Carta1,Carta2,Carta3,Carta4]),!.


robar_random(0,mazo).
robar_random(1,descarte).

robar_greedy(DeadwoodMano,DeadwoodDescarte,descarte) :- DeadwoodMano >= DeadwoodDescarte,!. %igual si la carta del descarte forma meld, el Deadwood no aumenta
robar_greedy(_,_,mazo).

% ####################################################################################
% descartar(+OldMano, +CartasVistas, +Estrategia, ?NewMano, ?NewDescarte)
% Este predicado decide qué carta vamos a descartar. En el momento del descarte, OldMano 
% tiene 11 cartas (ya robó). Debe cumplirse que: NewDescarte es una carta que aparece 
% en OldMano; NewMano es OldMano sin una ocurrencia de esa carta; por tanto, NewMano tiene 10 cartas.

% Estrategia RANDOM
descartar(OldMano,_,random,NewMano,NewDescarte) :- 
    select_random(OldMano, NewMano, NewDescarte).

% Estrategia GREEDY
% ¿Cual es la opcion localmente optima para descartar en cada mano?
% Descarto la que tiene mayor valor y no rompe melds
descartar(OldMano,_,greedy,NewMano,NewDescarte) :- 
    best_melds(OldMano,_,Sobrantes,_),!,
    maxL(Sobrantes,c(a,_),NewDescarte),
    select(NewDescarte,OldMano,NewMano),!.
    
% Estrategia PRO
% Mejor estrategia que greedy para descartar?
% Lo que hace greedy lo tenemos que mantener
% Utilizar de alguna forma CartasVistas para descartar la de mayor valor que no puede formar
% un meld dado que la que falta para formar el meld esta en cartas vistas
descartar(OldMano, CartasVistas, pro, NewMano, NewDescarte) :-
    best_melds(OldMano,_,Sobrantes,_),
     format('Sobrantes = ~w~n', [Sobrantes]),
    proyectos_meld(Sobrantes, MeldsProyecto, SobrantesSobrantes),
     format('Proyectos de Meld: ~w | SobrantesSobrantes:~w~n', [MeldsProyecto, SobrantesSobrantes]),
    descartar_pro(OldMano, CartasVistas, MeldsProyecto, SobrantesSobrantes, NewMano, NewDescarte),!.

% proyectos_meld(+Sobrantes, ?MeldsProyecto, ?SobrantesSobrantes) - Se cumple si MeldsProyecto es una lista de proyectos de Meld
% conjuntos de parejas de cartas del mismo palo e igual numero o cartas consecutivas, Sobrantes las cartas que quedan sin pareja. Se 
% minimiza el valor de SobrantesSobrantes. Es analogo a best_melds con la diferencia de que se consideran melds parejas de cartas consecutivas 
% o cartas de igual numero.

% best_melds_sobrantes(Sobrantes, MeldsProyecto, SobrantesSobrantes) :-
%     findall((M,S), get_melds_sobrantes(Sobrantes,M,S), Melds),
%     best_melds_rec(Melds,MeldsProyecto,SobrantesSobrantes,_,[],[],110).

proyectos_meld(Sobrantes, MeldsProyecto, SobrantesSobrantes) :-
    findall(M, get_melds_sobrantes(Sobrantes,M,_), Melds),
    proyecto_melds_rec(Melds,MeldsProyecto,[]),
    flatten(MeldsProyecto,MeldsProyectoF),
    subtract(Sobrantes,MeldsProyectoF,SobrantesSobrantes).

proyecto_melds_rec([M|Melds],MeldsProyecto,Macc) :-
    \+ member(M,Macc),
    proyecto_melds_rec(Melds,MeldsProyecto, [M|Macc]),!.
proyecto_melds_rec([_|Melds],MeldsProyecto,Macc) :-
    proyecto_melds_rec(Melds,MeldsProyecto, Macc),!.
proyecto_melds_rec([],M,M).


% analogo a get_melds, con la diferencia de que se consideran melds parejas de cartas consecutivas 
% o cartas de igual numero.
get_melds_sobrantes(Cartas, Melds, Sobrantes) :-
    particion(Cartas, P),
    filter_melds(P, Melds, SobrantesSet, is_meld_proyect),
    flatten(SobrantesSet,Sobrantes).

is_meld_proyect([C1,C2]) :- siguiente(C1,C2),!. 
is_meld_proyect([C1,C2]) :- siguiente(C2,C1),!.
is_meld_proyect([C1,C2]) :- igual_valor(C1,C2),!. 


% casos 
    % Todas son SobrantesSobrantes
    % Todas son MeldsProyecto
    % Hay MeldsProyecto y Sobrantes
    %     Si para un meldProyecto la que falta ya salio, descarto mas grande de ese proyecto
    %     Si no, descarto mayor de SobrantesSobrantes
% Todas son SobrantesSobrantes
descartar_pro(OldMano,_, [], SobrantesSobrantes, NewMano, NewDescarte) :-
    maxL(SobrantesSobrantes,c(a,_),NewDescarte),
    select(NewDescarte,OldMano,NewMano),!.

% Todos son proyectos de Meld y existe uno que no se puede completar porque la que falta esta en cartas vistas
descartar_pro(OldMano, CartasVistas, MeldsProyecto,[], NewMano, NewDescarte) :-
    select(P,MeldsProyecto,_),
    completa_meld(P,CartasVistas),!,
    maxL(P,c(a,_),NewDescarte),        
    select(NewDescarte, OldMano, NewMano),!.

%Todas son proyectos de meld que pueden completarse
descartar_pro(OldMano,_, MeldsProyecto, [], NewMano, NewDescarte) :-
    flatten(MeldsProyecto, Sobrantes),
    maxL(Sobrantes,c(a,_),NewDescarte),
    select(NewDescarte,OldMano,NewMano),!.

% Hay melds y SobranteSobrantes, para un meld la carta que lo completa esta en cartas vistas
descartar_pro(OldMano, CartasVistas, MeldsProyecto,_, NewMano, NewDescarte) :-
    select(P,MeldsProyecto,_),
    completa_meld(P,CartasVistas),!,
    maxL(P,c(a,_),NewDescarte),        
    select(NewDescarte, OldMano, NewMano),!.

% Ningun proyecto de meld se completa con cartas vistas, descarto la mayor de SobrantesSobrantes
descartar_pro(OldMano, _, _, SobrantesSobrantes, NewMano, NewDescarte) :-
    maxL(SobrantesSobrantes,c(a,_),NewDescarte),       
    select(NewDescarte, OldMano, NewMano),!.

% completa_meld(+ProyectoMeld, +CartasVistas) - Se cumple si existe una carta en CartasVistas que completa ProyectoMeld
completa_meld(ProyectoMeld, CartasVistas) :-
    select(C,CartasVistas,_),
    % append(ProyectoMeld,[C],Meld),
    is_meld([C|ProyectoMeld]).
 
% select_random(OldMano, NewMano, Carta) - se cumple si oldMano + {Carta} = OldMano
select_random(OldMano, NewMano, Carta) :-
    random_between(0,10,R),  
    select_n(Carta,R,OldMano,NewMano).

% select_n(S,N,L,R) - Se cumple si S es el elemento de la posicion N en L y R es L sin S
select_n(S,N,L,R) :- select_n_rec(S,N,L,R,0).

select_n_rec(S,N,[L|Ls],[L|R],Pos) :-
    N > Pos,!,
    N1 is Pos + 1,
    select_n_rec(S,N,Ls,R,N1).
select_n_rec(L,Pos,[L|Ls],Ls,Pos).

% select_Max(+Cartas, ?Max, ?R) - Se cumple si Max es la carta Maxima de Cartas y R es Cartas sin Max  
% select_max(Cartas, Max, R) :- 
%     maxL(Cartas, c(a,_), Max),
%     select(Max, Cartas, R). 

% MaxL(+Cartas,+MaxAcc,?M) - M es la carta mayor de la lista Cartas
maxL([H|T],Max,M) :- 
    max(H,Max,Max1),!,
    maxL(T,Max1,M).
maxL([],X,X).

% ####################################################################################
% cerrar(+Mano, +CartasVistas, +Estrategia, ?Decision)
% Este predicado decide si continuamos jugando o si cortamos. 
% Mano tiene 10 cartas (ya descartó en ese turno). 
% Decision ∈ {continuar, cortar}. Si Decision = cortar, 
% debe cumplirse la regla de legalidad: deadwood ≤ 10.

% Estrategia RANDOM
cerrar(Mano,_,random,Decision) :- 
    random_between(0,1,R),
    decision_random(R,D),
    best_melds(Mano, _,_,Valor),
    cerrar_random(D,Valor,Decision),!.

% Estrategia GREEDY    
cerrar(Mano,_,greedy,continuar) :-
    best_melds(Mano,_,_,Valor),
    Valor > 10,!.
cerrar(_,_,greedy,cortar).

% Estrategia PRO
% Cual seria una estrategia mejor que greedy para cerrar?
% Si ya esta en menos de diez puntos
% - para todo set si es de tres y la que falta no esta en cartas vistas seguir
% - si existe run, y la que sigue o la antecedente no esta en vartas vistas seguir
cerrar(Mano,CartasVistas,pro,Decision) :-
    best_melds(Mano, Melds,Sobrantes,Valor),
    % format('Melds => ~w~n', [Melds]),
    % format('Sobrantes => ~w~n', [Sobrantes]),   
    findall(D,cerrar_pro(Melds,CartasVistas,Valor,D), Decisiones),
    % format('Decisiones => ~w~n', [Decisiones]),   
    seleccionar_decision_pro(Decisiones,Decision).

seleccionar_decision_pro(Decisiones, continuar) :- member(continuar,Decisiones),!.
seleccionar_decision_pro(_, cortar). 

cerrar_pro(_,_,0,cortar) :- !.
cerrar_pro(_,_,Valor,continuar) :- Valor > 10,!.

% Deadwood menor que 10 
cerrar_pro(Melds,CartasVistas,_,Decision) :- 
    member(M,Melds),
    cerrar_pro_set_or_run(M, CartasVistas, Decision).

cerrar_pro_set_or_run([c(N,P)|Ms], CartasVistas, continuar) :-
    is_set([c(N,P)|Ms]),
    \+ member(c(N,_),CartasVistas),!.

cerrar_pro_set_or_run(Meld, CartasVistas, continuar) :-
    is_run(Meld),
    minL(Meld,c(k,_),Min),
    anterior(Min,AnteriorMin),
    \+ member(AnteriorMin,CartasVistas),!,
    maxL(Meld,c(a,_),Max),
    siguiente(Max,SiguienteMax),
    \+ member(SiguienteMax,CartasVistas),!.
cerrar_pro_set_or_run(_,_,cortar).

decision_random(0,cortar).
decision_random(1,continuar).

cerrar_random(continuar,_,continuar).
cerrar_random(cortar,Valor,cortar) :- Valor =< 10.
cerrar_random(cortar,Valor,continuar) :- Valor > 10.
