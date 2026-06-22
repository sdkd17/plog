/* Ejemplos:
    ?- rotar_uno_izq([1,2,3,4,5],R).
    R = [2, 3, 4, 5, 1].
*/
rotar_uno_izq([],[]). 
rotar_uno_izq([X],[X]).
rotar_uno_izq([L|Ls], R) :- insertar_final(L, Ls, R).

% insertar_final(X,L,R) <- La lista R es el resultado de insertar el elemento X al final de la lista L

/* Ejemplos:
    ?- insertar_final(5, [1,2,3,4,5], R).
    R = [1,2,3,4,5].
*/
insertar_final(X, [], [X]).
insertar_final(X, [L|Ls], [L|R]) :- insertar_final(X, Ls, R). 


% rotar_uno_der(L,R) <- La lista R es el resultado de rotar la lista L un lugar a la derecha.

/* Ejemplos:
    ?- rotar_uno_der([1,2,3,4,5],R).
    R = [5,1,2,3,4].
*/
rotar_uno_der([],[]). 
rotar_uno_der([X],[X]).
rotar_uno_der(Ls, [U|R]) :- ultimo(Ls,U), sin_ultimo(Ls,R).

%ultimo(L,U) <- U es el valor del ultimo elemento de la lista
ultimo([U],U).
ultimo([_|Xs],U) :- ultimo(Xs,U).

%sin_ultimo(L,R) <- R es la lista L sin el ultimo elemento 
sin_ultimo([_],[]).
sin_ultimo([X|Xs], [X|R]) :- sin_ultimo(Xs,R). 

% devuelve la lista de los primero N elementos
primeros_n2(_,N,N,[]).
primeros_n2([L|Ls],AccN,N,[L|R]) :-
    AccN1 is AccN + 1,
    primeros_n2(Ls, AccN1, N, R).


largo([_|T],Acc,L) :- 
    Ac1 is Acc + 1, 
    largo(T,Ac1,L).
largo([],L,L).


ultimos_n(L,N,R) :- 
    reverso(L,Lrev,Largo), 
    M is N mod Largo,
    primeros_n(Lrev,0,M,[],R).