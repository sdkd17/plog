% L = {a^Nb^Mc^Nd^M / N,M >= 0}

s    --> a(N),b(M),c(N),d(M).
a(0) --> [].
a(N) --> [a],a(N1),{N is N1 + 1}.
b(0) --> [].
b(N) --> [b],b(N1),{N is N1 + 1}.
c(0) --> [].
c(N) --> [c],c(N1),{N is N1 + 1}.
d(0) --> [].
d(N) --> [d],d(N1),{N is N1 + 1}.

ss --> s1(a,N),s1(b,M),s1(c,N),s1(d,M).
s1(_,0) --> [].
s1(A,N) --> [A],s1(A,N1),{N is N1 + 1}.