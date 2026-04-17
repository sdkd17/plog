
generar_pares(N,(I,J)) :-
  N1 is N - 1,
  between(0,N1,I),
  between(0,N1,J).

adyacente((I1, J1), (I1, J2), N) :- J2 is J1 + 1, J1 < N-1.
adyacente((I1, J1), (I1, J2), N) :- J2 is J1 - 1, J1 > 0.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 + 1, I1 < N-1.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 - 1, I1 > 0.

%todos los caminos posibles de Ini a Fin en un tablero de tamanio N
caminos(N, Ini, Fin, C, L) :- caminos_acc(Ini,Fin, N, [], C, 0, L).

caminos_acc((I1,J1),(I1,J1),_,R,R,RLenghtAcc,RLenghtAcc).

caminos_acc((I1,J1),(I2,J2),N,Visitados,R,RLenghtAcc, RLength) :-  
  generar_pares(N,(X1,X2)),
  \+ member((X1,X2), Visitados),
  adyacente((I1,J1),(X1,X2),N),
  RLenght1 is RLenghtAcc + 1,
  caminos_acc((X1,X2),(I2,J2),N,[(X1,X2)|Visitados],R, RLenght1, RLength).

% N tamanio del tablero
% Lista de Pares inicio fin
% Caminos Acumulador caminos generados hasta el momento
% CaminosLength Largo de Caminos para validar que cubro todo el tablero
% Visitados Acumulador Para validar que no se crucen los caminos

numberLink(N,[],Caminos,CaminosLength,_,Caminos) :- CaminosLength is (N*N) - 1. %Si visite todos los nodos llego a una solucion.

numberLink(N,[(Ini,Fin)|Ps], Caminos, CaminosLength, Visitados, C) :-
  caminos(N,Ini,Fin,R,RLength), %Busco un camino entre Ini y Fin
  append(R, Visitados, VisitadosAcc), % 
  CaminosLength1 is CaminosLength + RLength,
  \+ intersect(R,VisitadosAcc), %El nuevo camino no se cruza con otro nodo ya visitado
  numberLink(N, Ps, [R|Caminos], CaminosLength1, VisitadosAcc,C).
  
%interseccion de conjuntos/listas  
intersect(L1,L2) :-
  member(X,L1),
  member(X,L2).


% Agregar a L2 todos los elementos de L1
% addAll([],L2,L2).
% addAll([L|L1], L2, R) :-
%   addAll(L1,[L|L2],R).



insertar(X,L,[X|L]).

generar_lista(N,L) :- generar_lista_acc(N,N,L,[]).

generar_lista_acc(_,0,AccL,AccL).
generar_lista_acc(N,Acc,L,AccL) :-
  Acc > 0,
  Acc1 is Acc-1,
  generar_lista_acc(N,Acc1,L,[Acc|AccL]).
  


% generar_lista2(N,L,Acc) :- 
%   between(0,N,X),
%   select(X,Acc,L). 


