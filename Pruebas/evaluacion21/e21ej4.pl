% a) not_member_ld(+X,?L) ← X es un elemento que no está presente en la lista de diferencias L
% utilizada con la notación L-LR. Por ejemplo:
%   not_member_ld(6,[1,2,3,4|LR]-LR). ← Devuelve “true”.
%   not_member_ld(4,[1,2,3,4|LR]-LR). ← Devuelve “false”.

%not_member_ld(X,L-LR) :- \+ member(X,L). Esto no anda, evalua en true en la variable del final de la lista
not_member(X,L-LR) :- \+ member_ld(X,L-LR).

member_ld(X,[X|_]-_).
member_ld(X,[_|Ls]-LR) :-
    Ls \== LR,
    member_ld(X,Ls-LR).

not_member_ld(_,L-L) :- var(L),!.
not_member_ld(X,[Y|L]-LR):-
    X \= Y,
    not_member_ld(X,L-LR).

% b) Utilizando DCG, define un programa Prolog para reconocer el lenguaje:
% L = {an bn^2 / n ≥ 0}

s --> ss(a,N),ss(b,M), {M is N*N}.

ss(A,N) --> [A],ss(A,N1), {N1 is N + 1}.

% ##############################
% s --> a(N),b(M),{M is N*N}.
% a(N) -> [a],a(N1),{N1 is N + 1}.
% b(N) -> [b],b(N1),{N1 is N + 1}.