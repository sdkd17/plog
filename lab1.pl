% pertenece(?X,?L) ← El elemento X pertenece a la lista L


/*
Ejemplos:
    ?- pertenece(a,[a,b,c]).
    true .
    
    ?- pertenece(X,[a,b,c]). X=a;
    X=b;
    X=c;
    false.
*/

pertenece(X,[X|_]).
pertenece(X, [_|Ls]) :- pertenece(X,Ls).

% seleccionar(?X,?L,?L1) ← La lista L1 es el resultado de eliminar una ocurrencia del elemento X de la lista L.

/*
 Ejemplos:
    ?- seleccionar(3,[1,3,5,3], L).
    L = [1, 5, 3] ;
    L = [1, 3, 5] ;
    false.

    ?- seleccionar(3,L,[1,2]).
    L = [3, 1, 2] ;
    L = [1, 3, 2] ;
    L = [1, 2, 3].
*/

% seleccionar(_, [], []).
% seleccionar(X, [X|Ls], Ls).ß
% seleccionar(X, [L|Ls], L1) :- seleccionar(X, Ls, L2),  append([L], L2, L1).

seleccionar(_, [], []).
seleccionar(X, [X|Ls], Ls).
seleccionar(X, [Y|Ls], [Y|L1]) :- seleccionar(X, Ls, L1).

% rotar(+L,+N,-R) ← La lista R es el resultado de rotar la lista L N veces hacia la izquierda. Si N es negativo, el movimiento será hacia la derecha. N puede ser mayor al tamaño de la lista. 

/*Ejemplos:
    ?- rotar([1,2,3,4,5],1,R).
    R = [2, 3, 4, 5, 1].
  
    ?- rotar([1,2,3,4,5],-1,R).
    R = [5, 1, 2, 3, 4].
  
    ?- rotar([1,2,3,4,5],8,R).
    R = [4, 5, 1, 2, 3].
*/

rotar(Ls,0,Ls).
rotar([L|Ls], N, R) :- 
    rotar(R, N1, R1), 
    append(Ls, [L], R1), 
    N is N1+1.








