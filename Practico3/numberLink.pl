
generar_pares(N,(I,J)) :-
  N1 is N - 1,
  between(0,N1,I),
  between(0,N1,J).

adyacente((I1, J1), (I2, J2), N) :- I1 =:= I2, J2 is J1 + 1, J1 < N-1.
adyacente((I1, J1), (I2, J2), N) :- I1 =:= I2, J2 is J1 - 1, J1 > 0.
adyacente((I1, J1), (I2, J2), N) :- J1 =:= J2, I2 is I1 + 1, I1 < N-1.
adyacente((I1, J1), (I2, J2), N) :- J1 =:= J2, I2 is I1 - 1, I1 > 0.

%todos los caminos posibles de Ini a Fin

camino((I1,J1),(I2,J2),N,R,R) :- adyacente((I1,J1),(I2,J2),N).

camino((I1,J1),(I2,J2),N,Visitados,R) :-  
  generar_pares(N,(X1,X2)),
  \+ member((X1,X2), Visitados),
  adyacente((I1,J1),(X1,X2),N),
  camino((X1,X2),(I2,J2),N,[(X1,X2)|Visitados],R).


  


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


