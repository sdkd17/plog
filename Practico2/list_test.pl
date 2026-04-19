delete([X|Xs],X,Xs).
delete([X|Xs],Z,[X|Ys]) :- delete(Xs,Z,Ys).
delete([],_,[]).

insertar_inicio(X,L,[X|L]).


reverso(X,R) :- reverso_acc(X,R,[]).

reverso_acc([],Acc,Acc).
reverso_acc([X|Xs],R,Acc) :-
    reverso_acc(Xs,R,[X|Acc]).

insertar_final(X,L,R) :- reverso(L,R1),insertar_inicio(X,R1,R).

append_end([],X,[X]).
append_end([H|T],X,[H|R]) :- append_end(T,X,R).

lista()
lista(X,Y,[E|L]) :-
    between(X,Y,E).