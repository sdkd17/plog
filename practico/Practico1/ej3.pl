%EJERCICIO 3

nat(0).
nat(s(X)) :- nat(X).

%suma(X,Y,S) <- S es la suma de X e Y 
suma(0,X,X).
suma(s(X),Y,s(Z)) :- suma(X,Y,Z).

%resta(X,Y,R) <- R es la diferencia entre X e Y
resta(X,Y,R) :- suma(Y,R,X).

%producto(X,Y,P) <- P es el producto entre X e Y (P=X*Y)
producto(0,_,0). 
producto(s(X),Y,P) :- producto(X,Y,P1),suma(P1,Y,P).

%distintos(X,Y) <- X e Y son distintos
distintos(0,s(_)).
distintos(s(_),0).
distintos(s(X),s(Y)) :- distintos(X,Y).

%mayor(X,Y) <- X es mayor que Y (X > Y)
mayor(s(_),0).
mayor(s(X),s(Y)) :- mayor(X,Y).

%factorial(X,Y) <- Y es el gactorial de X (Y = X!)
factorial(0,s(0)).
factorial(s(X),Y) :- factorial(X,F),producto(F,s(X),Y).

%potencia(X,Y,Z) <- Z = X^Y
potencia(s(_),0,s(0)).
potencia(X,s(Y),Z) :- potencia(X,Y,P),producto(P,X,Z).