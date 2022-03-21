int: N; % dimension of the cessboard
% int: L; % number of L shapes
% int: S; % number of squares
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


% CONSTRAINTS

% putting black boxes on chessboard
constraint forall(i in B)(chessboard[blackBoxes[i,1],blackBoxes[i,2]] == 1);


% SOLVING CRITERIA
solve satisfy;


% OUTPUT
output [ show_int(2,chessboard[i,j]) ++ 
         if j == N then "\n" else " " endif |
         i in dimension, j in dimension
];