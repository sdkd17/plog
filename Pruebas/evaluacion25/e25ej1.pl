% a) suma_cuadrados(+L, ?N) - L es una lista de numeros unicos, N es el resultado de sumar el cuadrado de todos esos numeros.
% Ej: suma_cuadrados([2,3], 13).

suma_cuadrados(L,N) :- suma_cuadrados_rec(L,N,0).

suma_cuadrados_rec([],Acc,Acc).
suma_cuadrados_rec([X|Ls],N,Acc) :-
  AccSum is Acc + X,
  suma_cuadrados_rec(Ls,N,AccSum).

% cuadrados_menores(+N,?L) - N es un entero positivo, L es una lista de todos los enteros positivos que tenga un cuadrado
% menor o igual a N.
% Ej: cuadrados_menores(60,[1,2,3,4,5,6,7]).

cuadrados_menores2(N,L) :- cuadrados_menores_rec(N,L,1,[]).

cuadrados_menores_rec(N,Acc,Cont,Acc) :- 
   X2 = Cont*Cont,
   X2 > N,!.

cuadrados_menores_rec(N,L,Cont,Acc) :- 
  X2 is Cont*Cont,
  X2 =< N,
  Cont1 is Cont + 1,
  cuadrados_menores_rec(N,L,Cont1,[Cont|Acc]).

cuadrados_menores(N,L) :- 
  Sqrt is sqrt(N),
  T is truncate(Sqrt),
  findall(X,between(0,T,X),L).

% descomposicion_cuadrada(+N,L) - N es un entero positivo , L es una descomposicion cuadrada de N 
% como la definida anteriormente.

descomposicion_cuadrada(N,L) :-
  cuadrados_menores(N,C),
  descomposicion_cuadrada_acc(N,C,L,_).

descomposicion_cuadrada_acc(_,[],[],0).
descomposicion_cuadrada_acc(N,CuadradosMenores,Acc,Sum) :-
  select(X,CuadradosMenores,Resto),
  descomposicion_cuadrada_acc(N,Resto,Acc,Sum1),
  X2 is X*X,
  Sum is X2 + Sum1,
  insertar(N,Acc,X,Sum).

insertar(N,[X|_],X,Sum) :- Sum =< N.



