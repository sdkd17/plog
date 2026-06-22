%l_dl(L,R-Rx) - R-Rx es L como diferencia de listas
l_dl([L|Ls],[L|R]-Rx) :- l_dl(Ls,R-Rx).
l_dl([],Rx-Rx).