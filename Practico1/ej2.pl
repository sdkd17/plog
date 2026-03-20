%Ejercicio2
%Indique si las siguientes unificaciones son válidas. ¿Cómo quedan los términos
%unificados y la instanciación de variables luego de cada unificación?

i) X = juan.
%Valida => X = juan.
ii) 42 = X.
%Valida => X = 42.
iii) X = juan, 42 = X.
%Valida => false.
iv) X = juan, X = Y.
%Valida => X = Y, X = juan.
v) padre(Z,juan) = padre(jorge,juan).
%Valida => Z = jorge.
vi) quiere(ana,X) = quiere(Y,pedro).
%Valida => Y = ana, X = pedro.
vii) quiere(ana,X) = quiere(X,pedro).
%Valida => false. (X = ana, X = pedro. no puede suceder)
viii) g(f(X,Y),X,h(a))=g(f(b,Z),W,h(Z)).
%Valida => f(X,Y) = f(b,Z), X = W, h(a) = h(z)
%       => X = b, Y = Z, X = W, a = Z.
ix) g(f(X,Y),X,h(a)) = g(f(b,Z),W,h(X)).
%Valida => f(X,Y) = f(b,Z), X = W, a = X.
%       => X = b, Y = Z, X = W, a = X.
%       => false.
x) X = f(X).
% Ver teorico occurs_check, queda un loop infinito
xi) s(X,f(X)) = s(f(Z),Z).
% => X = f(Z), f(X) = Z
% => X = f(f(X)). analogo a anterior
xii) a(f(Y),W,g(Z)) = a(X,X,V).
%Valida => f(Y) = X, W = X, g(Z) = V
xiii) b(f(Y),W,g(Z)) = b(V,X,V).
% => f(Y) = V, W = X, g(Z) = V
% => f(Y) = g(Z) no es el mismo functor
% => false. 
xiv) c(a,X,f(g(Y))) = c(Z,h(Z,W),f(W)).
% => a = Z, X = h(Z,W), f(g(Y) = f(W))
% => a = Z, X = h(Z,W), g(Y) = W
% => Z = a, X = h(a,W), g(Y) = W
% => Z = a, X = h(a,g(y)), g(Y) = W
