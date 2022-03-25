include "globals.mzn";

int: N; % dimension of the cessboard
% int: L; % number of L shapes
int: S; % number of squares
int: R; % number of rectangles

int: num_blackBoxes;
set of int: B = 1..num_blackBoxes;
array[B,1..2] of int: blackBoxes;
set of int: dimension = 1..N;

% 1 represents blackBox
% 2 represents L shape
% 3 represents square
% 4 represents rectangle

array[dimension,dimension] of var 0..4: chessboard;


% *******************
% PREDICATES
% *******************

predicate square(var int: i1, var int: i2, var int: j1, var int: j2) = 
  (i1 = i2 + 1 \/ i1 = i2 - 1) /\ (j1 = j2 + 1 \/ j1 = j2 - 1) /\
  chessboard[i1,j1] = 3 /\ chessboard[i1,j2] = 3 /\ chessboard[i2,j1] = 3 /\ chessboard[i2,j2] = 3;
  
  
predicate rectangle(var int: i1, var int: j1, var int: i2, var int: j2, var int: i3, var int: j3) =
  (((i1 = i2 /\ i2 = i3) /\ ((j2 = j1+1 \/ j2 = j1-1) /\ (j3 = j2+1 \/ j3 = j2-1) /\ (j3 != j1))) \/
  ((j1 = j2 /\ j2 = j3) /\ ((i2 = i1+1 \/ i2 = i1-1) /\ (i3 = i2+1 \/ i3 = i2-1) /\ (i3 != i1)))) /\
  (chessboard[i1,j1] = 4 /\ chessboard[i2,j2]=4 /\ chessboard[i3,j3] = 4);

  
%predicate l_shape(var int: i1, var int: j1, var int: i2, var int: j2, var int: i3, var int: j3) = ...;
  
% *******************
% CONSTRAINTS
% *******************

% Squares ----------------------------------------------------------------------------------------------------------------

% putting black boxes on chessboard
constraint forall(i in B)(chessboard[blackBoxes[i,1],blackBoxes[i,2]] == 1);

% creation of squares coordinates
array[1..S,1..4] of var int: sq;

% squares should not overlap
constraint forall(i,j in 1..S where i !=j )(
                            if sq[i,3] == sq[j,3] \/ sq[i,4] == sq[j,4] \/ sq[i,3] == sq[j,4] \/ sq [i,4] == sq[j,3] 
                            then sq[i,1] != sq[j,1] /\ sq[i,2] != sq[j,2] /\ sq[i,1] != sq[j,2] /\ sq[i,2] != sq[j,1]
                            else
                              if sq[i,1] == sq[j,1] \/ sq[i,2] == sq[j,2] \/ sq[i,1] == sq[j,1] \/ sq [i,2] == sq[j,2] 
                              then sq[i,3] != sq[j,3] /\ sq[i,4] != sq[j,4] /\ sq[i,3] != sq[j,4] /\ sq[i,4] != sq[j,3]
                              endif
                            endif);


% putting square shapes on chessboard
constraint forall(i in 1..S)(square(sq[i,1], sq[i,2], sq[i,3], sq[i,4]));

% Rectangles --------------------------------------------------------------------------------------------------------------

array[1..R,1..6] of var int: rect;

% rectangles do not overlap

constraint forall(i,j in 1..R where i!=j)((rect[i,1]!=rect[j,1]\/rect[i,2]!=rect[j,2]) /\
                                          (rect[i,1]!=rect[j,3]\/rect[i,2]!=rect[j,4]) /\
                                          (rect[i,1]!=rect[j,5]\/rect[i,2]!=rect[j,6]) /\
                                          (rect[i,3]!=rect[j,3]\/rect[i,4]!=rect[j,4]) /\
                                          (rect[i,3]!=rect[j,5]\/rect[i,4]!=rect[j,6]) /\
                                          (rect[i,5]!=rect[j,5]\/rect[i,6]!=rect[j,6]));

constraint forall(i in 1..R)(rectangle(rect[i,1], rect[i,2], rect[i,3], rect[i,4], rect[i,5], rect[i,6]));



% Other constraints ----------------------------------------------------------------

constraint chessboard[1,1] = 1 \/ chessboard[1,1] = 2 \/ chessboard[1,1] = 3 \/ chessboard[1,1] = 4;
constraint sum(i,j in dimension)(chessboard[i,j]==1)<=num_blackBoxes;

% *******************
% SOLVING 
% *******************
solve satisfy;


% *******************
% OUTPUT
% *******************

output [ show_int(2,chessboard[i,j]) ++ 
         if j == N then "\n" else " " endif |
         i in dimension, j in dimension 
]++["\nSquares coordinates ",show(sq)]++["\nRectangles coordinates ",show(rect)];