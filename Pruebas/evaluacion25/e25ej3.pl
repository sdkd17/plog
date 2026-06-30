f(X,Y) :- g(X,Y).
f(0,0).
g(X,Y) :- p(X),q(Y),!.
g(X,Y) :- f(X,Y).
p(1).
p(2).
q(1).
q(2).
q(3).

