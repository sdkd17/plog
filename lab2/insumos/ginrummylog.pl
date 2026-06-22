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

is_set(Cartas) :-
    length(Cartas,L),
    L > 2,
    L < 5,
    mismo_valor_todas(Cartas),
    palos_distintos(Cartas).

mismo_valor_todas([_]).
mismo_valor_todas([c(V,_),c(V,_)|Cs]) :- mismo_valor_todas([c(V,_)|Cs]).

palos_distintos([]).
palos_distintos([c(_,P)|Cs]) :-
    \+ member(c(_,P),Cs),
    palos_distintos(Cs).

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
min(c(A,P),c(A,P),c(A,P)).
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
siguiente(c(10,P), c(j,P)).
siguiente(c(j,P), c(q,P)).
siguiente(c(q,P), c(k,P)).

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
% es un meld válido. Este predicado toma subconjuntos de la mano y va descartando en función
% de si son Melds válidos o no. Y va armando el conjunto de melds.
get_melds(Mano, [Meld|Melds], Sobrantes) :-
    subconjunto(Mano, Meld),
    length(Meld, L),
    L >= 3,
    L =< 10,
    is_meld(Meld), 
    restar_listas(Mano, Meld, RestoMano),
    get_melds(RestoMano, Melds, Sobrantes).

get_melds(Mano, [], Mano). % Caso base: las cartas que queden son sobrantes.



% subconjunto(+ListaOriginal, ?Subconjunto)

% Caso base: El conjunto vacío es subconjunto de cualquier lista.
subconjunto([], []).

% Opción 1: El elemento cabeza (H) se incluye en el subconjunto.
subconjunto([H|T], [H|Sub]) :-
    subconjunto(T, Sub).

% Opción 2: El elemento cabeza (H) se excluye del subconjunto.
subconjunto([_|T], Sub) :-
    subconjunto(T, Sub).

% restar_listas(+ManoOriginal, +ElementosAExtraer, ?ManoRestante)

% Caso base: Si no hay elementos que extraer, la mano queda intacta.
restar_listas(Mano, [], Mano).

% Caso recursivo: Selecciona y quita una ocurrencia de H de la mano, 
% y luego continúa restando la cola (T).
restar_listas(Mano, [H|T], ManoRestante) :-
    select(H, Mano, ManoAux),
    restar_listas(ManoAux, T, ManoRestante).


% get_melds(+Mano, ?Melds, ?Sobrantes): Melds es una lista de listas; cada sublista
% es un meld válido. Este predicado puede ser no determinista: una misma mano
% puede admitir varias descomposiciones. En ningún caso importa el orden de las
% listas. Observar que este predicado genera todas las descomposiciones, la que
% minimiza el valor del deadwood y las que no.
%get_melds(Mano, Melds, Sobrantes) :-
    % generar subconjuntos de Mano  
%    particion(Mano, P),
%    filter_melds(P, Melds,SobrantesSet),
%    flatten(SobrantesSet,Sobrantes).

%filter_melds([P|Ps], Melds,Sobrantes)  :- filtrar(P,Ps,Melds,Sobrantes).
%filter_melds([],[],[]).

%filtrar(P,Ps,[P|Melds],Sobrantes) :-
%    is_meld(P),!,
%    filter_melds(Ps,Melds,Sobrantes).

%filtrar(P,Ps,Melds,[P|Sobrantes]) :-
%    filter_melds(Ps,Melds,Sobrantes).

% particion(+L,?P) - se cumple si P es una particion de L agrupando por numero de carta o por palo
%particion([L|Ls], P) :-
%    particion(Ls,Prec),
%    tres_opciones(L,Prec,P).
%particion([],[]).

% tres_opciones(+L,+Particion,?NuevaParticion) - NuevaParticion es la particion P agregando el elemento L
% Agrega a L como:
%    - un nuevo conjunto
%    - Lo agrega a un conjunto de P que contenga una carta del mismo palo que L
%    - Lo agrega a un conjunto de P que contenga una carta del mismo valor
%tres_opciones(L,Particion,[[L]|Particion]).

%tres_opciones(L,Particion,P) :- 
%    select_mismo_numero(L,Pi,Particion,R),
%    append([[L|Pi]],R,P).

%tres_opciones(L,Particion,P) :- 
%    select_mismo_palo(L,Pi,Particion,R),
%    append([[L|Pi]],R,P).

% select_mismo_numero(+C,?P,?Particion,?R) - selecciona en P un elemento de Particion que contiene 
% una carta del mismo valor que C. R es Particion - {P}
%select_mismo_numero(C,[Ci|Pi],Particion,R) :-
%    select([Ci|Pi],Particion,R),
%    igual_valor(C,Ci).

% select_mismo_numero(+C,?P,?Particion,?R) - selecciona en P un elemento de Particion que contiene 
% una carta del mismo palo que C. R es Particion - {P}
%select_mismo_palo(C,[Ci|Pi],Particion,R) :-
%    select([Ci|Pi],Particion,R),
%    igual_palo(C,Ci).

% ####################################################################################
% best_melds(+Mano, ?MejorMelds, ?Sobrante, ?Valor) - De todas las particiones
% que pueden obtenerse via get_melds nos quedamos con la que minimiza el valor del 
% deadwood. Si hay varias particiones que minimizan este valor puede devolverse 
% cualquiera de ellas. Tiene la restricción de que MejorMelds no puede 
% tener más de 10 cartas.

best_melds(Mano,MejorMelds,Sobrante,Valor) :- 
    % format('Mano => ~w~n',[Mano]),
    findall((M,S), get_melds(Mano,M,S),Melds),
    best_melds_rec(Melds,MejorMelds,Sobrante,Valor,[],[],111).

best_melds_rec([(M,_)|Melds],MejorMelds,Sobrante,Valor,BestMeld,Leftovers,Min) :-
    cantidad_cartas_melds(M,Cant),
    Cant > 10,!,
    best_melds_rec(Melds,MejorMelds,Sobrante,Valor,BestMeld,Leftovers,Min).
best_melds_rec([(M,S)|Melds],MejorMelds,Sobrante,Valor,BestMeld,Leftovers,Min) :-
    valor_deadwood(S,V),
    % write(M), write('-'), write(S), write('=>'), write(V), write('\n'), 
    minMeld(M,S,V,BestMeld,Leftovers,Min,Mnuevo,Snuevo,MinNuevo),
    best_melds_rec(Melds,MejorMelds,Sobrante,Valor,Mnuevo,Snuevo,MinNuevo).
best_melds_rec([],M,S,V,M,S,V).

cantidad_cartas_melds([M|Ms],Cant) :-
    length(M,L),
    cantidad_cartas_melds(Ms,Cant1),
    Cant is L + Cant1.
cantidad_cartas_melds([],0).

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
% selecciono el tope del descarte si disminuye el deadwood
robar(Mano,Descarte,_,greedy,Lugar) :-
    best_melds(Mano,_,_,DeadwoodMano),
    best_melds([Descarte|Mano],_,_,DeadwoodDescarte),
    robar_greedy(DeadwoodMano,DeadwoodDescarte,Lugar).

% Estrategia PRO
% Cual seria una mejor estrategia que greedy para robar?
% Miro que pasaria si robo el descarte y despues descarto la mejor carta
robar(Mano,Descarte,CartasVistas,pro,Lugar) :-
    puntaje_mano(Mano,CartasVistas,PuntajeActual),
    descartar([Descarte|Mano],CartasVistas,pro,ManoNueva,_),
    puntaje_mano(ManoNueva,CartasVistas,PuntajeDescarte),
    robar_pro(PuntajeActual,PuntajeDescarte,Lugar).

robar_random(0,mazo).
robar_random(1,descarte).

robar_greedy(DeadwoodMano,DeadwoodDescarte,descarte) :- DeadwoodMano > DeadwoodDescarte,!.
robar_greedy(_,_,mazo).

robar_pro(PuntajeActual,PuntajeDescarte,descarte) :- PuntajeDescarte < PuntajeActual,!.
robar_pro(_,_,mazo).

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
% Descarto la que genera un menor deadwood al tirarla.
descartar(OldMano, _, greedy, NewMano, NewDescarte) :- 
    findall((Deadwood, Carta, ManoRestante),
        (select(Carta, OldMano, ManoRestante),
         best_melds(ManoRestante, _, _, Deadwood)),
        Opciones),
    sort(Opciones, [(MinDeadwood, NewDescarte, NewMano)|_]), !.

% Estrategia PRO
% Mejor estrategia que greedy para descartar?
% Lo que hace greedy lo tenemos que mantener
% Utilizar de alguna forma CartasVistas para descartar la de mayor valor que no puede formar
% un meld dado que la que falta para formar el meld esta en cartas vistas
descartar(OldMano,CartasVistas,pro,NewMano,NewDescarte) :-
    findall((Puntaje,ValorCarta,Carta,Mano),
        (select(Carta,OldMano,Mano),
         puntaje_mano(Mano,CartasVistas,Puntaje),
         valor(Carta,Valor),
         ValorCarta is -Valor),
        Opciones),
    sort(Opciones,[(_,_,NewDescarte,NewMano)|_]),!.

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

% puntaje_mano(+Mano,+CartasVistas,?Puntaje) - puntaje chico es mejor
puntaje_mano(Mano,CartasVistas,Puntaje) :-
    best_melds(Mano,_,Sobrantes,Deadwood),
    potencial_sobrantes(Sobrantes,Mano,CartasVistas,Potencial),
    Puntaje is Deadwood * 10 - Potencial.

potencial_mano(Mano,CartasVistas,Potencial) :-
    best_melds(Mano,_,Sobrantes,_),
    potencial_sobrantes(Sobrantes,Mano,CartasVistas,Potencial).

potencial_sobrantes([C|Cs],Mano,CartasVistas,Potencial) :-
    potencial_carta(C,Mano,CartasVistas,P1),
    potencial_sobrantes(Cs,Mano,CartasVistas,P2),
    Potencial is P1 + P2.
potencial_sobrantes([],_,_,0).

potencial_carta(Carta,Mano,CartasVistas,Puntos) :-
    findall(1,carta_cerca(Carta,Mano,CartasVistas),L),
    length(L,Puntos).

carta_cerca(c(V,P),Mano,_) :-
    member(c(V,P2),Mano),
    P \= P2.
carta_cerca(c(V,P),Mano,_) :-
    valor_siguiente(A,V),
    member(c(A,P),Mano).
carta_cerca(c(V,P),Mano,_) :-
    valor_siguiente(V,S),
    member(c(S,P),Mano).
carta_cerca(c(V,P),Mano,CartasVistas) :-
    valor_siguiente(A,V),
    \+ member(c(A,P),Mano),
    \+ member(c(A,P),CartasVistas).
carta_cerca(c(V,P),Mano,CartasVistas) :-
    valor_siguiente(V,S),
    \+ member(c(S,P),Mano),
    \+ member(c(S,P),CartasVistas).
carta_cerca(c(V,P),Mano,CartasVistas) :-
    palo_valido(P2),
    P \= P2,
    \+ member(c(V,P2),Mano),
    \+ member(c(V,P2),CartasVistas).

palo_valido(c).
palo_valido(d).
palo_valido(t).
palo_valido(p).

valor_siguiente(a,2).
valor_siguiente(2,3).
valor_siguiente(3,4).
valor_siguiente(4,5).
valor_siguiente(5,6).
valor_siguiente(6,7).
valor_siguiente(7,8).
valor_siguiente(8,9).
valor_siguiente(9,10).
valor_siguiente(10,j).
valor_siguiente(j,q).
valor_siguiente(q,k).

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
% Si la mano es buena corta, si todavia puede mejorar bastante sigue jugando
% El jugador decide arriesgarse a no cortar (teniendo <= 10 de deadwood) 
% solo si el total de sus cartas sobrantes tiene al menos 10 "salidas" o 
% cartas útiles esperándolo en el mazo.
cerrar(Mano,CartasVistas,pro,Decision) :-
    best_melds(Mano,_,_,Valor),
    cerrar_pro(Mano,CartasVistas,Valor,Decision),!.

cerrar_pro(_,_,Valor,continuar) :- 
    Valor > 10,!.
cerrar_pro(_, _, 0, cortar) :- !.

cerrar_pro(Mano, CartasVistas, Valor, continuar) :- 
    potencial_mano(Mano, CartasVistas, Potencial),
    Potencial >= 10,
    !.

cerrar_pro(_, _, _, cortar).
    
decision_random(0,cortar).
decision_random(1,continuar).

cerrar_random(continuar,_,continuar).
cerrar_random(cortar,Valor,cortar) :- Valor =< 10.
cerrar_random(cortar,Valor,continuar) :- Valor > 10.