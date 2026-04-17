hijo(juan,pedro).
hijo(pedro,ana).
hijo(ana,laura).
hijo(laura,jose).

descendiente(X,Y):- hijo(X,Y).
descendiente(X,Y):- hijo(X,Z), descendiente(Z,Y).