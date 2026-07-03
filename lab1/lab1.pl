%SERGIO DANIEL KLEIN DURAN
%JOAQUIN GUANI SANZ
%LUKAS BERNARD KASEK ANTUNEZ
%GUILLERMO MAXIMILIANO FRANCO SUNES

%pertenece(?X,?L) ← Devuelve true si el elemento X pertenece a la lista L
pertenece(X,[X|_]).
pertenece(X, [Y|Ls]) :- X \== Y, pertenece(X,Ls).

%seleccionar(?X,?L,?L1) ← La lista L1 es el resultado de eliminar una ocurrencia del elemento X de la lista L.
seleccionar(X, [X|Ls], Ls).
seleccionar(X, [Y|Ls], [Y|L1]) :- seleccionar(X, Ls, L1).

/*dividir(+L, +N, -A, -B) ← La lista A contiene los primeros N elementos de L y la lista B los restantes de L.*/
dividir(L, 0, [], L).
dividir([H|T], N, [H|A], B) :-
    N > 0,
    N1 is N - 1,
    dividir(T, N1, A, B).

/*rotar(+L,+N,-R) ← La lista R es el resultado de rotar la lista L N veces hacia la izquierda.
Si N es negativo, el movimiento será hacia la derecha. N puede ser mayor al tamaño de la
lista.*/
rotar(L,0,L).
rotar(L, N, Resultado) :-
    length(L, Largo),
    Largo > 0,
    N1 is N mod Largo,          
    dividir(L, N1, A, B),
    append(B, A, Resultado).

/*rotar_varias(+L, +Pares,-R) ← dada una Lista L, y una lista Pares de pares (N,Dir),
la lista R es el resultado de aplicar una rotación por cada par, donde N indica la cantidad de
posiciones, y Dir puede ser izquierda o derecha.*/
rotar_varias(L, [], L).
rotar_varias(L, [(N, izquierda)|T], R) :-
    rotar(L, N, L1),
    rotar_varias(L1, T, R).
rotar_varias(L, [(N, derecha)|T], R) :-
    N1 is -N,
    rotar(L, N1, L1),
    rotar_varias(L1, T, R).

/*producto_escalar(+A, +B, -R). ← R es el resultado de realizar la suma del producto entrada a entrada de las listas A y B.*/
producto_escalar([], [], 0).
producto_escalar([Ai|F], [Bj|C], Resultado):- producto_escalar(F, C, RecRes), Resultado is Ai * Bj + RecRes.  

/*separar_cabezas(+M, -Col, -Resto). ← dada una matriz M, devuelve la primer columna de M en Col y la matriz restante en Resto.*/
separar_cabezas([], [], []).
separar_cabezas([[E|Cola] | Filas], [E|Entradas], [Cola|Restos]) :-
    separar_cabezas(Filas, Entradas, Restos).

/*trasponer(+M, -MT). ← dada una matriz M, la matriz MT es el resultado de trasponer M.*/
trasponer([[]|_], []).
trasponer([[F1|RestoFila] | FilasRestantes], [FilaTraspuesta | MatrizRestante]) :-
    separar_cabezas([[F1|RestoFila] | FilasRestantes], FilaTraspuesta, Restos),
    trasponer(Restos, MatrizRestante).

/*fila_por_matriz(+F, +M, -P). ← dada un array F y una matriz M, P es el resultado de realizar el producto de F con cada fila de M.*/
fila_por_matriz(_,[],[]).
fila_por_matriz(F,[BTraspuesta1| Resto],[P|Producto]):-producto_escalar(F,BTraspuesta1,P), fila_por_matriz(F, Resto, Producto).

/*matriz_por_matriz(+A, +B, -R). ← dada las matrices A y B, R es el resultado de realizar el producto escalar entre las filas de A por las filas de B*/
matriz_por_matriz([], _, []).
matriz_por_matriz([A1|FilasRA], BTraspuesta, [R1|Restantes]):- fila_por_matriz(A1,BTraspuesta,R1), 
    matriz_por_matriz(FilasRA, BTraspuesta, Restantes).

/*multiplicar_matrices (+A,+B,-R) ← Dadas dos matrices A y B, representadas como
listas de listas de números, R es el resultado de multiplicar ambas matrices. De acuerdo a las
reglas de multiplicación de matrices, la cantidad de columnas de la matriz A debe ser igual a
la cantidad de filas de la matriz B. */
multiplicar_matrices(A,B,R):-trasponer(B,BTraspuesta), matriz_por_matriz(A,BTraspuesta,R).


/* numberlink(+N,+Puntos,-C) ← Si N es un número que representa el tamaño del tablero, y
Puntos una lista de pares (Inicial,Final), siendo Inicial y Final a su vez pares
(Fila,Columna), que indican posiciones en el tablero. entonces C será una lista de caminos
que resuelve el problema. Cada camino será a su vez una lista de pares (Fila,Columna)
que comienza en el primer componente de cada elemento de Puntos, y termina en el
segundo. */

numberlink(N, Puntos, C) :-
    generarCasillasDesde(1, 1, N, Puntos, Casillas),
    porCasillasPrimero(Casillas, Puntos, C).


/* generarCasillasDesde(+F, +C, +N, +Puntos, -Casillas) ← 
Genera en Casillas todas las posiciones del tablero N x N que no
están ocupadas por Puntos, comenzando en la fila F y columna C.
Así, dados F, C y N, solo hay una solución posible.*/

generarCasillasDesde(F, _, N, _, []) :-
    F > N.

generarCasillasDesde(F, C, N, Puntos, Casillas) :-
    F =< N,
    C > N,
    F1 is F + 1,
    generarCasillasDesde(F1, 1, N, Puntos, Casillas).

generarCasillasDesde(F, C, N, Puntos, [(F, C) | Resto]) :-
    F =< N,
    C =< N,
    noPerteneceAPunto((F, C), Puntos),
    C1 is C + 1,
    generarCasillasDesde(F, C1, N, Puntos, Resto).

generarCasillasDesde(F, C, N, Puntos, Resto) :-
    F =< N,
    C =< N,
    perteneceAPunto((F, C), Puntos),
    C1 is C + 1,
    generarCasillasDesde(F, C1, N, Puntos, Resto).


/* porCasillasPrimero(+Casillas, +Puntos, -Caminos) ← dada la lista de puntos libres Casillas y la lista de valores iniciales Puntos,
Inicia la construcción del camino para el primer par de puntos, colocando el origen al inicio de la lista Caminos y delega la busqueda de
los puntos intermedios a porCasillas. Además asegura la restricción de que todas las casillas esten ocupadas al recorrer todos los caminos.*/

porCasillasPrimero([], [], []).

porCasillasPrimero(Casillas, [((IX, IY), (FX, FY)) | Puntos], [[(IX, IY) | Resto] | Caminos]) :-
    porCasillas(Casillas, [((IX, IY), (FX, FY)) | Puntos], [Resto | Caminos]).


/*porCasillas(+Casillas, +Puntos, -Caminos) ← Construye el camino intermedio hasta el final.*/

porCasillas(Casillas, [((IX, IY), (FX, FY)) | Puntos], [[(FX, FY)] | Caminos]) :-
    estanPegados((IX, IY), (FX, FY)),
    porCasillasPrimero(Casillas, Puntos, Caminos).

porCasillas(Casillas, [((IX, IY), (FX, FY)) | Puntos], [[(CX, CY) | Resto] | Caminos]) :-
    seleccionar((CX, CY), Casillas, Casillas2),
    estanPegados((CX, CY), (IX, IY)),
    porCasillas(Casillas2, [((CX, CY), (FX, FY)) | Puntos], [Resto | Caminos]).


/*noPertenece(+X, +L) ← Devuelve true si X no pertenece a la lista L.*/

noPertenece(_, []).
noPertenece(X, [Y | Ys]) :-
    X \= Y,
    noPertenece(X, Ys).


/*perteneceAPunto(+X, +Puntos) ← Devuelve true si X es un punto inicial o final de algún par de Puntos.*/

perteneceAPunto(X, [(X, _) | _]).
perteneceAPunto(X, [(_, X) | _]).
perteneceAPunto(X, [_ | Ys]) :-
    perteneceAPunto(X, Ys).


/*noPerteneceAPunto(+X, +Puntos) ← Devuelve true si X no es ni punto inicial ni punto final
de ningún par de Puntos.*/

noPerteneceAPunto(_, []).
noPerteneceAPunto(X, [(H, F) | Ys]) :-
    X \= H,
    X \= F,
    noPerteneceAPunto(X, Ys).


/*estanPegados(+P1, +P2) ← Devuelve true si P1 y P2 son adyacentes.*/

estanPegados((X1, Y1), (X2, Y2)) :-
    X1 =:= X2,
    D is Y1 - Y2,
    (D =:= 1 ; D =:= -1).

estanPegados((X1, Y1), (X2, Y2)) :-
    Y1 =:= Y2,
    D is X1 - X2,
    (D =:= 1 ; D =:= -1).
