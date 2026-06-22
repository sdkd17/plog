%Ejercicio 4

nat(0).
nat(s(X)) :- nat(X).

% a) Predicados sobre Listas

% largo(L,N) <- la lista L tiene N elementos
largo([],0).
largo([_|Xs],s(N)) :- 
    largo(Xs,N).

% ultimo(L,X) <- X es el ultimo elemento de la lista L.
ultimo([X],X).
ultimo([_|Xs],X) :- ultimo(Xs,X).

% sin_ultimo(L,S) <- S es la lista que se obitene de suprimir el ultimo elemento de L
sin_ultimo([[_]], []).
sin_ultimo([X|Xs],[X|S]) :- sin_ultimo(Xs,S).

% reverso(L,R) <- La lista R contiene los elemento de la lista L en orde inverso
reverso([],[]).
reverso([X|Xs], R) :- reverso(Xs,W),append(W,[X],R).
%Es ineficiente: cuando el tamanio de la lista es grande demora mucho en responder

reverso2(L,R) :- reverso_acc(L,[],R).

reverso_acc([],Acc,Acc).
reverso_acc([X|Xs],Acc,R) :-
    reverso_acc(Xs,[X|Acc],R).

% subsecuencia(L,S) <- La lista S contiene elementos (no necesariamente consecutivos) de
% la lista L. Estos elementos preservan el orden de aparición que poseen en L.
% [1,3,5] es subsecuendia de [1,2,3,4,5]
% [1,5,3] no es subsecuendia de [1,2,3,4,5] no respeta el orden
subsecuencia([],[]).
subsecuencia([X|Xs],[X|S]) :- subsecuencia(Xs,S).
subsecuencia([_|Xs],S) :- subsecuencia(Xs,S).

%sublista(L,S) <- La lista S contiene elementos consecutivos de la lista L.
% Estos elementos preservan el orden de aparición que poseen en L.
% [1,3,5] no es suublista de [1,2,3,4,5]
% [2,3] es sublista de [1,2,3,4,5]

sublista(L,S) :- append(P,_,L),append(_,S,P).
%primero me quedo con un prefijo de L, y sobre ese prefijo me quedo con los prefijos.

%prefijo(L,P) <- La lista P es un prefijo de L 
prefijo([],_).
prefijo([X|Xs],[X|P]):- prefijo(Xs,P).

prefijo2(L,P) :- append(P,_,L).

%sufijo(L.S) <- La lista S es un sufijo de L
sufijo(L,L).
sufijo(L,S):- append(_,S,L).

%borrar_todos(L,X,B) <- B es la lista L sin ocurrencias del elemento X
borrar_todos([],_,[]).
borrar_todos([X|Xs],X,B) :- borrar_todos(Xs,X,B).
borrar_todos([W|Ws],X,[W|Bs]) :- borrar_todos(Ws,X,Bs).



%sin_repetidos(L,S) <- La lista S es la lista L sin elementos repetidos.
% sin_repetidos(L,S) :- sin_repetidos_acc(L,[],S) 
