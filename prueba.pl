%l_dl(L,R-Rx) - R-Rx es L como diferencia de listas
l_dl([L|Ls],[L|R]-Rx) :- l_dl(Ls,R-Rx).
l_dl([],Rx-Rx).


lista_mas_larga([L|Ls], Mayor) :-
    lista_mas_larga_acc(Ls, L, Mayor).

lista_mas_larga_acc([], Mayor, Mayor).

lista_mas_larga_acc([L|Ls], Actual, Mayor) :-
    mas_larga(L, Actual, NuevaActual),
    lista_mas_larga_acc(Ls, NuevaActual, Mayor).

mas_larga(L1, L2, L1) :-
    length(L1, N1),
    length(L2, N2),
    N1 > N2.

mas_larga(L1, L2, L2) :-
    length(L1, N1),
    length(L2, N2),
    N1 =< N2.