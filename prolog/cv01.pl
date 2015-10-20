city(as).
city(brno).
% ?- city(as).
% ?- city(tokio).
% ?- city(X). <Space>
city(as,10000).
city(brno,250000).
% ?- city(Y,X),X>100000.
smaller(X,Y):-city(X,P1), city(Y,P2), P1<P2.
% ?- smaller(as,brno).
% ?- smaller(brno,as).

fac(0,1).
fac(N,F) :- N>0, M is N-1,
	fac(M,Fm), F is N*Fm.
% ?- fac(4,X).

