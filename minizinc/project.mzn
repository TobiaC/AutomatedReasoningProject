include "globals.mzn";

int: N; % dimension of the cessboard
% int: L; % number of L shapes
int: S; % number of squares
% int: R; % number of rectangles

int: num_blackBoxes;
set of int: B = 1..num_blackBoxes;
array[B,1..2] of int: blackBoxes;
set of int: dimension = 1..N;

% 0 represents free cell
% 1 represents blackBox
% 2 represents L shape
% 3 represents square
% 4 represents rectangle
array[dimension,dimension] of var 0..4: chessboard;

%PREDICATES
predicate square(var int: i1, var int: i2, var int: j1, var int: j2) = 
  (i1 = i2 + 1 \/ i1 = i2 - 1) /\ (j1 = j2 + 1 \/ j1 = j2 - 1) /\
  chessboard[i1,j1] == 3 /\ chessboard[i1,j2] == 3 /\ chessboard[i2,j1] == 3 /\ chessboard[i2,j2] == 3;
  

% CONSTRAINTS

% putting black boxes on chessboard
constraint forall(i in B)(chessboard[blackBoxes[i,1],blackBoxes[i,2]] == 1);

% putting square shapes on chessboard
array[1..S,1..4] of var int: sq;

%constraint forall(i,j in 1..S where i!=j)(sq[i,1] != sq[j,1] \/ sq[i,2] != sq[j,2] \/ sq[i,3] != sq[j,3] \/ sq[i,4] != sq[j,4]);

constraint forall(i,j in 1..S where i !=j )(
                            if sq[i,3] == sq[j,3] \/ sq[i,4] == sq[j,4] \/ sq[i,3] == sq[j,4] \/ sq [i,4] == sq[j,3] 
                            then sq[i,1] != sq[j,1] /\ sq[i,2] != sq[j,2] /\ sq[i,1] != sq[j,2] /\ sq[i,2] != sq[j,1]
                            else
                              if sq[i,1] == sq[j,1] \/ sq[i,2] == sq[j,2] \/ sq[i,1] == sq[j,1] \/ sq [i,2] == sq[j,2] 
                              then sq[i,3] != sq[j,3] /\ sq[i,4] != sq[j,4] /\ sq[i,3] != sq[j,4] /\ sq[i,4] != sq[j,3]
                              endif
                            endif);

constraint forall(i in 1..S)(square(sq[i,1], sq[i,2], sq[i,3], sq[i,4]));


% SOLVING CRITERIA
solve satisfy;

% OUTPUT
output [ show_int(2,chessboard[i,j]) ++ 
         if j == N then "\n" else " " endif |
         i in dimension, j in dimension 
]++[show(sq)];