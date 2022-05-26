
% GENERATE

% cell (a cell cannot have more than one value)
1 { cell(X,Y,V) : cellvalue(V)} 1 :- dimension(X), dimension(Y).

% free space
free(cell(X,Y,V)) :- cell(X,Y,V), V=0.

% black boxes
cell(X,Y,1) :- blackBox(X,Y).
blackbox(cell(X,Y,V)) :- cell(X,Y,V), V=1.

% square shape
s {square(cell(X,Y,V),cell(X,Y1,V),cell(X1,Y,V),cell(X1,Y1,V)) : cell(X,Y,V),cell(X,Y1,V),cell(X1,Y,V),cell(X1,Y1,V), X1=X+1, Y1=Y+1} s :- V=2.


% TEST

% constraint on the number of cells with value 1 (black boxes)
num_bb(B) :- B=#count{X,Y : blackBox(X,Y)}.
B {cell(X,Y,V) : cell(X,Y,V), V=1} B :- num_bb(B).



% constraint on the number of cell with value 2 (squares)
s*4 {cell(X,Y,V) : cell(X,Y,V), V=2} s*4.







% SHOW
%#shownum_bb/1.
%#showblackbox/1.
%#showfree/1.
#showsquare/4.
#showcell/3.