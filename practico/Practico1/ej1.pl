%EJERCICIO 1
progenitor(X,Y) :- .
distintos(X,X) :- .
casados(X,Y) :- .

% hermano(X,Y) <- X e Y son hermanos.
hermano(X,Y) :- distintos(X,Y),progenitor(Z,X),progenitor(Z,Y).

% tio(X,Y) <- X es tio de y
tio(X,Y) :- hermano(X,Z),progenitor(Z,Y).

% tio_politico(X,Y) <- X es tio politico de Y
tio_politico(X,Y) :- casados(X,Z),tio(Z,Y).

% cuniado(X,Y) <- X e Y con cuniados
cuniado(X,Y) :- casado(X,Z),hermano(Z,Y).

% concuniado(X,Y) <- X e Y son concuniado

% suegro(X,Y) <- X es suegro de Y
suegro(X,Y) :- progenitor(X,Z)k,casado(Y,Z).

% consuegro(X,Y) <- X e Y son consuegros 

