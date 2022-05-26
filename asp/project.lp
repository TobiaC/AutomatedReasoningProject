dimension(1..n).
cellvalue(0..1).
blackBox(1,3).
blackBox(1,1).

% GENERATE

cell(X,Y,V) :- not cell(X,Y,V1), V!=V1, dimension(X), dimension(Y), cellvalue(V), cellvalue(V1).

num_bb(B) :- B=#count{X,Y : blackBox(X,Y)}.

B {cell(X,Y,V) : cell(X,Y,V)} B :- V=1, num_bb(B).

free(cell(X,Y,V)) :- cell(X,Y,V), V=0.

cell(X,Y,1) :- blackBox(X,Y).

blackbox(cell(X,Y,V)) :- cell(X,Y,V), V=1.

% DEFINE

% TEST

#shownum_bb/1.
#showblackbox/1.
#showfree/1.
#showcell/3.