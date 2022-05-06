include "globals.mzn";

int: N; % dimension of the chessboard
int: L; % number of L shapes in input
int: S; % number of squares in input
int: R; % number of rectangles in input


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% this is to allow to insert more figures in input while chosing to use just some of them
var int: rectangles_on_board;
constraint rectangles_on_board <= R;
constraint rectangles_on_board >= 1;

var int: ls_on_board;
constraint ls_on_board <= L;
constraint ls_on_board >= 1;

var int: squares_on_board;
constraint squares_on_board <= S;
constraint squares_on_board >= 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


int: num_blackBoxes;
set of int: B = 1..num_blackBoxes;
array[B,1..2] of int: blackBoxes;
set of int: dimension = 1..N;

% 1 represents blackBox
% 2 represents L shape
% 3 represents square weight: 4
% 4 represents rectangle wheight: 2

%% figures weights
int: rectangle_weight = 2;
int: l_shape_weight = 3;
int: square_weight = 4;

array[dimension,dimension] of var 0..5: chessboard;

%% the following are for representing the rectangle of free space
var int: i1; 
var int: i2;
var int: j1;
var int: j2;

var int: A = abs(i2-i1+1)*abs(j2-j1+1);

% *******************
% PREDICATES
% *******************

predicate square(var int: i1, var int: i2, var int: j1, var int: j2) = 
  (i1 = i2+1 \/ i1 = i2-1) /\ (j1 = j2+1 \/ j1 = j2-1) /\
  chessboard[i1,j1] = 3 /\ chessboard[i1,j2] = 3 /\ chessboard[i2,j1] = 3 /\ chessboard[i2,j2] = 3;

  
predicate rectangle(var int: i1, var int: j1, var int: i2, var int: j2, var int: i3, var int: j3) =
  (((i1 = i2 /\ i2 = i3) /\ ((j2 = j1+1 \/ j2 = j1-1) /\ (j3 = j2+1 \/ j3 = j2-1) /\ (j3 != j1))) \/
  ((j1 = j2 /\ j2 = j3) /\ ((i2 = i1+1 \/ i2 = i1-1) /\ (i3 = i2+1 \/ i3 = i2-1) /\ (i3 != i1)))) /\
  (chessboard[i1,j1] = 4 /\ chessboard[i2,j2]=4 /\ chessboard[i3,j3] = 4);

predicate l_shape(var int: i1, var int: j1, var int: i2, var int: j2, var int: i3, var int: j3) = 
  i2 = i3 /\ (j3 = j2+1 \/ j3 = j2-1) /\ (i1 = i2+1 \/ i1 = i2-1) /\ j1=j2 /\
  chessboard[i1,j1] = 2 /\ chessboard[i2,j2] = 2 /\ chessboard[i3,j3] = 2;
  

predicate free(var int: i1,var int:i2,var int:j1,var int:j2) = forall(i in i1..i2, j in j1..j2)(chessboard[i,j]=5);

 
% *******************
% CONSTRAINTS
% *******************

% Squares ------------------------------------------------

% putting black boxes on chessboard
constraint forall(i in B)(chessboard[blackBoxes[i,1],blackBoxes[i,2]] == 1);

% creation of squares coordinates
array[1..S,1..4] of var int: sq;

% squares should not overlap
constraint forall(i,j in 1..squares_on_board where i !=j )(
                            if sq[i,3] == sq[j,3] \/ sq[i,4] == sq[j,4] \/ sq[i,3] == sq[j,4] \/ sq [i,4] == sq[j,3] 
                            then sq[i,1] != sq[j,1] /\ sq[i,2] != sq[j,2] /\ sq[i,1] != sq[j,2] /\ sq[i,2] != sq[j,1]
                            else
                              if sq[i,1] == sq[j,1] \/ sq[i,2] == sq[j,2] \/ sq[i,1] == sq[j,1] \/ sq [i,2] == sq[j,2] 
                              then sq[i,3] != sq[j,3] /\ sq[i,4] != sq[j,4] /\ sq[i,3] != sq[j,4] /\ sq[i,4] != sq[j,3]
                              endif
                            endif);


% putting square shapes on chessboard
constraint forall(i in 1..squares_on_board)(square(sq[i,1], sq[i,2], sq[i,3], sq[i,4]));

% Rectangles ------------------------------------------------

array[1..R,1..6] of var int: rect;

% rectangles do not overlap
constraint forall(i,j in 1..rectangles_on_board where i!=j)((rect[i,1]!=rect[j,1]\/rect[i,2]!=rect[j,2]) /\
                                          (rect[i,1]!=rect[j,3]\/rect[i,2]!=rect[j,4]) /\
                                          (rect[i,1]!=rect[j,5]\/rect[i,2]!=rect[j,6]) /\
                                          (rect[i,3]!=rect[j,3]\/rect[i,4]!=rect[j,4]) /\
                                          (rect[i,3]!=rect[j,5]\/rect[i,4]!=rect[j,6]) /\
                                          (rect[i,5]!=rect[j,5]\/rect[i,6]!=rect[j,6]));

constraint forall(i in 1..rectangles_on_board)(rectangle(rect[i,1], rect[i,2], rect[i,3], rect[i,4], rect[i,5], rect[i,6]));

% L-shapes ------------------------------------------------
array[1..L,1..6] of var int: lc; %l-shape coordinates

% l shape do not overlap
constraint forall(i,j in 1..ls_on_board where i != j)((lc[i,1] != lc[j,1] \/ lc[i,2] != lc[j,2]) /\
                                            (lc[i,1] != lc[j,3] \/ lc[i,2] != lc[j,4]) /\
                                            (lc[i,1] != lc[j,5] \/ lc[i,2] != lc[j,6]) /\
                                            (lc[i,3] != lc[j,3] \/ lc[i,4] != lc[j,4]) /\
                                            (lc[i,3] != lc[j,5] \/ lc[i,4] != lc[j,6]) /\
                                            (lc[i,5] != lc[j,5] \/ lc[i,6] != lc[j,6]));
% putting l-shapes on chessboard
constraint forall(i in 1..ls_on_board)(l_shape(lc[i,1], lc[i,2], lc[i,3], lc[i,4], lc[i,5], lc[i,6]));


% Other constraints ------------------------------------------------

% top lef corner must  be occupied
constraint chessboard[1,1] = 1 \/ chessboard[1,1] = 2 \/ chessboard[1,1] = 3 \/ chessboard[1,1] = 4;

% cannot mark a cell with a number different than 0 if it is not part of a figure
constraint sum(i,j in dimension)(chessboard[i,j]==1)<=num_blackBoxes;
constraint sum(i,j in dimension)(chessboard[i,j]=2)<=ls_on_board*3;
constraint sum(i,j in dimension)(chessboard[i,j]=3)<=squares_on_board*4;
constraint sum(i,j in dimension)(chessboard[i,j]=4)<=rectangles_on_board*3;
constraint sum(i,j in dimension)(chessboard[i,j]=5)<=A;

% making the rectangle of free space
constraint i1<=N /\ i1 >= 1;
constraint i2<=N /\ i2 >= 1;
constraint j1<=N /\ j1 >= 1;
constraint j2<=N /\ j2 >= 1;
constraint i2>=i1;
constraint j2>=j1;

constraint forall(iS,iF in i1..i2, jS,jF in j1..j2)(free(iS,iF,jS,jF));
var int: zeros = sum(i,j in dimension)(chessboard[i,j]=0);

% *******************
% SOLVING 
% *******************

var int: total_weight = rectangles_on_board*rectangle_weight+squares_on_board+square_weight+ls_on_board*l_shape_weight;

solve maximize(total_weight); % maximize the area of the rectangle of free space


% *******************
% OUTPUT
% *******************

output [ show_int(2,chessboard[i,j]) ++ 
         if j == N then "\n" else " " endif |
         i in dimension, j in dimension 
]++["\nSquares coordinates ",show(sq)]++["\nRectangles coordinates ",show(rect)]++["\nL coordinates ", show(lc)]++["\nFree space rectangle area: ",show(A)]++
["\n i1: ",show(i1),"\n i2: ",show(i2),"\n j1: ",show(j1),"\n j2: ",show(j2)];