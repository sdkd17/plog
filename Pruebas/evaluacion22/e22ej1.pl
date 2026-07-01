% ejemplo:
vertice(a).
vertice(b).
vertice(c).
vertice(d).
vertice(e).
vertice(f).
vertice(g).
vertice(h).
vertice(i).

arista(a,c). 
arista(c,f).
arista(b,e).
arista(d,h).
arista(h,i).
arista(i,g).
arista(h,g).

% a) camino(+X,?Y) ← Existe un camino entre X e Y. Notar que se deben cumplir las condiciones
% indicadas anteriormente: las aristas se pueden recorrer en ambos sentidos y el grafo puede
% contener ciclos, por lo que hay que tener cuidado con esto en el programa.
camino(X,Y) :- camino_con_visitados(X,Y,[X]).
camino(X,Y) :- camino_con_visitados(Y,X,[Y]).

camino_con_visitados(X,X,_).
camino_con_visitados(X,Y,Visitados) :-
    vertice(Z),
    arista(X,Z),
    \+ member(Z,Visitados),
    camino_con_visitados(Z,Y,[Z|Visitados]).

% b) elegir_no_visitado(+Componentes,?V) ← V es un vértice del grafo que no pertenece a
% ninguna de las componentes que están en la lista Componentes. Por ejemplo:
elegir_no_visitado(Componentes, V) :- 
    flatten(Componentes,ComponentesFlattened),
    vertice(V),
    \+ member(V,ComponentesFlattened).

% c) componente_conexa(+V,?C) ← C es la componente conexa a la que pertenece el vértice V.
% Recordar que la componente conexa debe ser una lista sin elementos repetidos. Por ejemplo:
% componente_conexa(g,[g,d,h,i]).

componente_conexa(V,C) :- setof(W,camino(V,W),C).

% d) componentes_conexas(?C) ← C es la lista de todas las componentes conexas del grafo.
componentes_conexas(C) :- componentes_conexas_aux(C,[]).

componentes_conexas_aux(C,Acc) :-
    elegir_no_visitado(Acc,V),!, % No reevalua en cada eleccion de un no visitado
    componente_conexa(V,Comp),
    componentes_conexas_aux(C,[Comp|Acc]).
componentes_conexas_aux(C,C).

    