
generar_pares(N,(I,J)) :-
  N1 is N,
  between(1,N1,I),
  between(1,N1,J).

adyacente((I1, J1), (I1, J2), N) :- J2 is J1 + 1, J1 < N.
adyacente((I1, J1), (I1, J2), N) :- J2 is J1 - 1, J1 > 1.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 + 1, I1 < N.
adyacente((I1, J1), (I2, J1), N) :- I2 is I1 - 1, I1 > 1.

%todos los caminos posibles de Ini a Fin en un tablero de tamanio N
caminos(N, Ini, Fin, C, L, Visitados) :- caminos_acc(Ini,Fin, N, [Ini], C, 1, L, Visitados).

caminos_acc(X,X,_,Visitados,Visitados,RLenghtAcc,RLenghtAcc, _).

caminos_acc(I,F,N,Visitados,R,RLenghtAcc, RLength, VisitadosPorOtros) :-  
  generar_pares(N,P),
  \+ member(P, Visitados),
  \+ member(P, VisitadosPorOtros),
  adyacente(I,P,N),
  RLenght1 is RLenghtAcc + 1,
  caminos_acc(P,F,N,[P|Visitados],R, RLenght1, RLength, VisitadosPorOtros).

  
numberLink(N,Puntos,C) :- numberLink_acc(N,Puntos,[],C,[],0).

% N tamanio del tablero
% Lista de Pares inicio fin
% Caminos Acumulador caminos generados hasta el momento
% CaminosLength suma de Largo de Caminos para validar que cubro todo el tablero
% Visitados Acumulador Para validar que no se crucen los caminos

numberLink_acc(N,[],Caminos,Caminos,_,VisitadosLength) 
  % :- write(VisitadosLength). 
  :- VisitadosLength is (N*N).

numberLink_acc(N,[(Ini,Fin)|Ps], Caminos, C, Visitados, VisitadosLength) :-
  caminos(N,Ini,Fin,R,RLength, Visitados), %Busco un camino entre Ini y Fin, queda en R
  % write(RLength),
  % writeq('Caminos=>'),write(Ini),writeq('-'),write(Fin),writeln(Caminos),
  % writeq('R=>'),writeln(R),
  % writeq('visitados=>'),writeln(Visitados),
  
  \+ intersect(R,Visitados), %El nuevo camino no se cruza con otro nodo ya visitado
  append(R, Visitados, VisitadosAcc), % 
  VisitadosLength1 is VisitadosLength + RLength,
  
  numberLink_acc(N, Ps, [R|Caminos], C, VisitadosAcc, VisitadosLength1).
  
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


