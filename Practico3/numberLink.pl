/*
 Si N es un número que representa el tamaño del tablero, y Puntos una lista de pares (Inicial,Final), siendo Inicial y Final a su vez pares (Fila,Columna), que indican posiciones en el tablero. entonces C será una lista de caminos que resuelve el problema. Cada camino será a su vez una lista de pares (Fila,Columna) que comienza en el primer componente de cada elemento de Puntos, y termina en el segundo. Por convención, las filas del tablero están numeradas de arriba hacia abajo, y las columnas de izquierda a derecha. Los caminos deben devolverse en el mismo orden que los puntos que lo generan.
*/
numberLink(N,Puntos,C) :- numberLink_acc(N,Puntos,Puntos,[],C1,[],0), reverso(C1,C).





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
  

adyacente((I1, J1), (I1, J2), N) :- J2 is J1 + 1, J1 < N.
adyacente((I1, J1), (I1, J2), N) :- J2 is J1 - 1, J1 > 1.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 + 1, I1 < N.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 - 1, I1 > 1.



toListPuntos([],[],0).
toListPuntos([(I,J)|Puntos], [I,J|L], Length1) :-  
  toListPuntos(Puntos, L, Length),
  Length1 is Length + 1. 


  
%interseccion de conjuntos/listas  
intersect(L1,L2) :-
  member(X,L1),
  member(X,L2).

reverso(X,R) :- reverso_acc(X,R,[]).
reverso_acc([],Acc,Acc).
reverso_acc([X|Xs],R,Acc) :-
    reverso_acc(Xs,R,[X|Acc]).