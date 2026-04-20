% pertenece(?X,?L) <- El elemento X pertenece a la lista L


/*
Ejemplos:
    ?- pertenece(a,[a,b,c]).
    true .
    
    ?- pertenece(X,[a,b,c]). X=a;
    X=b;
    X=c;
    false.
*/

pertenece(X,[X|_]).
pertenece(X, [_|Ls]) :- pertenece(X,Ls).

% seleccionar(?X,?L,?L1) <- La lista L1 es el resultado de eliminar una ocurrencia del elemento X de la lista L.

/*
 Ejemplos:
    ?- seleccionar(3,[1,3,5,3], L).
    L = [1, 5, 3] ;
    L = [1, 3, 5] ;
    false.

    ?- seleccionar(3,L,[1,2]).
    L = [3, 1, 2] ;
    L = [1, 3, 2] ;
    L = [1, 2, 3].
*/

% seleccionar(_, [], []).
% seleccionar(X, [X|Ls], Ls).
% seleccionar(X, [L|Ls], L1) :- seleccionar(X, Ls, L2),  append([L], L2, L1).

seleccionar(_, [], []).
seleccionar(X, [X|Ls], Ls).
seleccionar(X, [Y|Ls], [Y|L1]) :- seleccionar(X, Ls, L1).

% rotar(+L,+N,-R) <- La lista R es el resultado de rotar la lista L N veces hacia la izquierda. Si N es negativo, el movimiento será hacia la derecha. N puede ser mayor al tamaño de la lista. 

/*Ejemplos:
    ?- rotar([1,2,3,4,5],1,R).
    R = [2, 3, 4, 5, 1].
  
    ?- rotar([1,2,3,4,5],-1,R).
    R = [5, 1, 2, 3, 4].
  
    ?- rotar([1,2,3,4,5],8,R).
    R = [4, 5, 1, 2, 3].
*/

rotar(L,N,R) :- 
    reverso(L,Lrev,Largo), %invierto la lista y obtengo largo al mismo tiempo
    M is N mod Largo,
    primeros_n_rev(Lrev,M,P), % primera parte del resultado
    M1 is Largo - M,
    primeros_n(L,M1,U), % segunda parte del resultado
    append(P,U,R). %concateno primera y segunda parte

% reverso(+L,?R,?Largo) <- Retorna en R la lista L invertida y retorna en Largo el largo de la lista

/* Ejemplo:
    ?- reverso([1,2,3,4,5], R, Largo).
    R = [5,4,3,2,1],
    Largo = 5.
*/
reverso(L,R,Largo) :- reverso_acc(L,[],R, Largo, 0).

reverso_acc([],Acc,Acc, LargoAcc, LargoAcc).
reverso_acc([X|Xs],Acc,R, Largo, LargoAcc) :-
    LargoAcc1 is LargoAcc + 1,
    reverso_acc(Xs,[X|Acc],R, Largo, LargoAcc1).

% primeros_n_rev(+L,+N,?R) <- devuelve en R la lista de los primeros N elementos de la lista L en orden inverso

/*Ejemplos:
    ?- primeros([1,2,3,4,5],3,R).
    R = [3,2,1].
*/
primeros_n_rev(L,N,R) :- primeros_n_rev_acc(L,0,N,[],R).

primeros_n_rev_acc(_,N,N,AccL,AccL).
primeros_n_rev_acc([L|Ls],AccN,N, AccL, R) :-
    AccN1 is AccN + 1,
    primeros_n_rev_acc(Ls, AccN1, N, [L|AccL], R).

%% primeros_n(+L,+N,?R) <- devuelve en R la lista de los primeros N elementos de la lista L

/*Ejemplos:
    ?- primeros([1,2,3,4,5],3,R).
    R = [1,2,3].
*/
primeros_n(L,N,R) :- primeros_n_acc(L,0,N,R).

primeros_n_acc(_,N,N,[]).
primeros_n_acc([L|Ls],AccN,N,[L|R]) :-
    AccN1 is AccN + 1,
    primeros_n_acc(Ls, AccN1, N, R).

% rotar_varias(+L, +Pares,-R) <- dada una Lista L, y una lista Pares de pares (N,Dir), la lista R es el resultado de aplicar una rotación por cada par, donde N indica la cantidad de posiciones, y Dir puede ser izquierda o derecha. 
/* Ejemplo:
    ?- rotar_varias([1,2,3,4,5],[(2, izquierda), (1, derecha), (3, izquierda)],R).
    R = [5, 1, 2, 3, 4].
*/

rotar_varias(L, [], L).
rotar_varias(L,[P|Ps], R) :- 
    rotar_una(L,P,L1), 
    rotar_varias(L1, Ps, R).

% rotar_una(L, (N,Dir), R) <- dada una Lista L, y un Par (N,Dir), la lista R es el resultado de aplicar una rotación a L, donde N indica la cantidad de posiciones, y Dir puede ser izquierda o derecha. 
rotar_una(L, (N,izquierda), R) :- 
    N1 is -1*N, 
    rotar(L,N1,R).
rotar_una(L, (N,derecha), R) :- 
    rotar(L,N,R). 

% multiplicar_matrices (+A,+B,-R) <- Dadas dos matrices A y B, representadas como listas de listas de números, R es el resultado de multiplicar ambas matrices. De acuerdo a las reglas de multiplicación de matrices, la cantidad de columnas de la matriz A debe ser igual a la cantidad de filas de la matriz B. 

/* Ejemplo:
    ?- multiplicar_matrices([[1,2,3],[4,5,6]], [[1,2],[3,4],[5,6]], R).
    R = [[22, 28], [49, 64]].
*/
multiplicar_matrices(A,B,R) :- multiplicar_matrices_acc(A,B,Rx,[]), reverso(Rx,R,_).


multiplicar_matrices_acc([],_,Acc,Acc).
multiplicar_matrices_acc([As|Ass], B, R, Acc) :-
    multiplicar_fila_x_matriz(As, B, Ri),
    multiplicar_matrices_acc(Ass, B, R, [Ri|Acc]).

multiplicar_fila_x_matriz(Ai, [Bs|Bss], R) :- 
    multiplicar_fila_x_matriz_acc(Ai, Bs, [Bs|Bss],0, Ri, []),
    reverso(Ri,R,_).

multiplicar_fila_x_matriz_acc(_,[],_,_,Acc,Acc).
multiplicar_fila_x_matriz_acc(Ai, [_|Bis], B, I, Ri, Acc) :- 
    obtener_columna(B, I, Bj),
    multiplicar_arrays(Ai, Bj, Rij),
    ISucc is I + 1,
    multiplicar_fila_x_matriz_acc(Ai, Bis, B, ISucc, Ri, [Rij|Acc]).

obtener_columna(B, Index, Rs) :- 
    obtener_columna_acc(B,Index, R1, []),
    reverso(R1,Rs,_).

obtener_columna_acc([], _,Acc,Acc).
obtener_columna_acc([Bs|Bss], Index, Rs, Acc) :-
    obtener_columna_acc(Bss, Index, Rs, [Bi|Acc]),
    obtener_i(Bs, Index, Bi).
    

obtener_i(L,Index,R) :- obtener_i_acc(L, Index, R, 0).

obtener_i_acc([L|_], Index, L, Index).
obtener_i_acc([_|Ls],Index, R, Acc) :-
    Acc1 is Acc + 1,
    obtener_i_acc(Ls, Index, R, Acc1).


multiplicar_arrays([],[],0).
multiplicar_arrays([A|As], [B|Bs], R) :-
    multiplicar_arrays(As,Bs, R1),
    R is A*B + R1.


/*
  Si N es un número que representa el tamaño del tablero, y Puntos una lista de pares (Inicial,Final),
  siendo Inicial y Final a su vez pares (Fila,Columna), que indican posiciones en el tablero. 
  entonces C será una lista de caminos que resuelve el problema. Cada camino será a su vez 
  una lista de pares (Fila,Columna) que comienza en el primer componente de cada elemento de Puntos, 
  y termina en el segundo. Por convención, las filas del tablero están numeradas de arriba hacia abajo, 
  y las columnas de izquierda a derecha. Los caminos deben devolverse en el mismo orden que los 
  puntos que lo generan.
*/
numberLink(N,Puntos,C) :- numberLink_acc(N,Puntos,Puntos,[],C1,[],0), reverso(C1,C,_).



% N Tamanio del tablero
% Puntos Lista de Puntos iniciales
% Puntos Lista de Puntos iniciales sobre la que se realiza recursion
% Caminos Acumulador de puntos que formaran un camino
% C El camino a retornar
% Acumulador de Puntos visitados
% Acumulador de tamanio de Lista de puntos
numberLink_acc(N,Puntos,[(Ini,Fin)|Ps], Caminos, C, Visitados, VLength) :-
  select((Ini,Fin), Puntos, PuntosAux), toListPuntos(PuntosAux,PuntosList,_), %Puntos iniciales menos Punto actual como Visitados
  caminos(N,PuntosList,Fin,Ini, Visitados, VLength, C1, NuevosVisitados, NVLength), 
  numberLink_acc(N, Puntos, Ps, [C1|Caminos], C, NuevosVisitados, NVLength).

% Paso base => Se cumple si Visite todo el tablero.
numberLink_acc(N,_,[],Caminos,Caminos,_,VLength) :- VLength is (N*N).

% N Tamanio del tablero
% Puntos Lista de Puntos iniciales sin el punto actual(Ini,Fin)
% Fin Punto final
% Ini Punto Inicial
% Visitados Lista de puntos ya visitados
% VLength Largo de lista de puntos visitados
% NuevoVisitados Nueva lista de visitados luego de encontrado un camino
% NVLength largo de nueva lista de visitados
caminos(N, Puntos, Fin, Ini, Visitados, VLength, C, NuevoVisitados, NVLength) :- 
  VLength1 is VLength + 1,
  caminos_acc(N, Puntos, Fin, Ini, [Fin|Visitados], VLength1, C, [Fin], NuevoVisitados, NVLength).


caminos_acc(N,Puntos,I,F,Visitados, VLength, C, Cacc, NuevoVisitados, NVLength) :-  
  generar_adyacente_no_visitado(N,I,Visitados,Puntos, P),
  VLength1 is VLength + 1,
  caminos_acc(N,Puntos,P,F,[P|Visitados],VLength1, C, [P|Cacc], NuevoVisitados, NVLength).

caminos_acc(_,_,X,X,Visitados,VLength,Cacc,Cacc,Visitados,VLength).

% N Tamanio del tablero
% P Punto para el que se retornar los adyacentes
% Lista de puntos visitados
% Puntos Lista de puntos Iniciales menos los puntos actuales (Ini, Fin)
% (I,J) Punto adyacente generado
generar_adyacente_no_visitado(N, P, Visitados, Puntos, (I,J)) :-
  N1 is N,
  between(1,N1,I),
  between(1,N1,J),
  adyacente(P,(I,J),N),
  \+ member((I,J), Puntos),
  \+ member((I,J), Visitados).
  

% Predicado para determinar si dos puntos son adyacentes en un tablero de
% tamanio N.
adyacente((I1, J1), (I1, J2), N) :- J2 is J1 + 1, J1 < N.
adyacente((I1, J1), (I1, J2), N) :- J2 is J1 - 1, J1 > 1.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 + 1, I1 < N.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 - 1, I1 > 1.


/* toListPuntos(+Puntos,L,Length) <- Devuelve en L una lista que contiene las posiciones 
  en el tablero definidas en Puntos y en Length el largo de L. 
  Ejemplo:
  ?- tiListPuntos([((1,1),(1,2)),((2,1),(2,2))] L, Length).
    L = [(2,1),(2,2),(1,1),(2,2)], 4)
    Length = 4.
*/
toListPuntos([],[],0).
toListPuntos([(I,J)|Puntos], [I,J|L], Length1) :-  
  toListPuntos(Puntos, L, Length),
  Length1 is Length + 1. 




    










