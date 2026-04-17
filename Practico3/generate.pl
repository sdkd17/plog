%permutaciones de L
perm(L,P) :- 
  select(X,L,L1),
  select(X,P,L1).

perm1([],[]).
perm1(L,[X|P]) :-
  select(X, L, L2),
  perm1(L2, P).

lista_dom(0,_,[]).
lista_dom(N, Dom,[X|R]) :-
  N > 0,
  N1 is N - 1,
  member(X,Dom),
  lista_dom(N1,Dom,R).

lista_creciente(N,L) :-
  lista_dom(N,[1,2,3,4],L),
  creciente(L).

creciente([]).
creciente([_]).
creciente([X1,X2|R]) :- X1 < X2, creciente([X2|R]).
