% a) cruce(?Origen, ?Destino, ?T):
% Tanto Origen como Destino están representados por el término estado(Izq,Der,Linterna), donde Izq y
% Der son listas ordenadas con las personas que están, respectivamente, a la izquierda y a la
% derecha del puente, y Linterna puede ser left o right, según el lado en el que se
% encuentra la linterna. Para que el cruce sea posible, la linterna debe estar del lado del lado
% del puente donde el cruce comienza.
% Ej:
%  - cruce(estado([a,b,c],[d],left),estado([a,b],[c,d],right),5).
demora(a,1).
demora(b,2).
demora(c,5).
demora(d,8).

% Cruza uno hacia la derecha
cruce(estado(Oizq,_,left), estado(_,Dder,right), T) :-
  select(X,Oizq,_),member(X,Dder),demora(X,T).
% cruzan dos hacia la derecha
cruce(estado(Oizq,_,left), estado(_,Dder,right), T) :-
  select(X1,Oizq,IzqR),member(X1,Dder),
  select(X2,IzqR,_),member(X2,Dder),
  demora(X1,D1),
  demora(X2,D2),
  max(D2,D1,T).
% Cruza uno hacia la izqierda
cruce(estado(_,Oder,right), estado(Dizq,_,left), T) :-
  select(X,Oder,_),member(X,Dizq),demora(X,T).
% cruzan dos hacia la izquierda
cruce(estado(_,Oder,right), estado(Dizq,_,left), T) :-
  select(X1,Oder,OderR),member(X1,Dizq),
  select(X2,OderR,_),member(X2,Dizq),
  demora(X1,D1),
  demora(X2,D2),
  max(D2,D1,T).



max(D1,D2,D1) :- D1 > D2.
max(D1,D2,D2) :- D2 >= D1.

% b) recorrido(?Camino,?T): existe una secuencia de cruces que resuelve el problema en
% un tiempo T, a partir de la configuración inicial. Camino es la lista de estados en la
% secuencia.

recorrido(Camino,T) :-
  