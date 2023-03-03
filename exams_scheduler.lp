
1 {exam_day(E,D): day(D)} 1     :- exam(E).
1 {exam_room(E,R): room(R)} 1   :- exam(E).
1 {exam_slot(E,L): slot(L)} 1   :- exam(E).

% days start from 1 (monday)
:- day(X), X<1.


%% cannot have two exams same day same room same slot
:- exam_day(E1,D), exam_day(E2,D), day(D),
    exam(E1), exam(E2),
    exam_room(E1,R), exam_room(E2,R), room(R),
    exam_slot(E1,L), exam_slot(E2,L), slot(L),
    E1 != E2.

% no exams on saturdays and sundays
:- exam_day(E,D), day(D), exam(E), D\7=6.
:- exam_day(E,D), day(D), exam(E), D\7=0.

total_exams(C)      :- C = #count{E : exam(E)}.
exams_booked(S,N)   :- N = #count{E : book(S,E), exam(E)}, student(S).
exams_bookable(S,N) :- N = #count{E : bookable(S,E), exam(E)}, student(S).

% a student that booked three or more exams should be able to do at least three exams
3 {bookable(S,E): exam(E), book(S,E)} N :- student(S), total_exams(C), exams_booked(S,N), N>2.

% a student that booked two or more exams should be able to do at least two exams
2 {bookable(S,E): exam(E), book(S,E)} N :- student(S), total_exams(C), exams_booked(S,N), N>1.

% a student that booked one exam should be able to do at least that exams
1 {bookable(S,E): exam(E), book(S,E)} N :- student(S), total_exams(C), exams_booked(S,N), N>0.


% a student cannot do two exams that have a distance less than two days
:- student(S),
    exam(E1), exam(E2),
    bookable(S,E1), bookable(S,E2), 
    day(D1), day(D2),
    exam_day(E1,D1), exam_day(E2,D2), 
    E1!=E2,
    |D1-D2|<=2.


exams_acceptable(S,N) :- N = #count{E : acceptable(S,E), exam(E)}, student(S).

N {acceptable(S,E): exam(E)} C :- student(S), total_exams(C), exams_bookable(S,N).


:- student(S),
    exam(E1), exam(E2),
    acceptable(S,E1), acceptable(S,E2), 
    day(D1), day(D2),
    exam_day(E1,D1), exam_day(E2,D2), 
    E1!=E2,
    |D1-D2|<=2.


:- student(S),
    exam(E1), exam(E2),
    acceptable(S,E1), bookable(S,E2), 
    day(D1), day(D2),
    exam_day(E1,D1), exam_day(E2,D2), 
    E1!=E2,
    |D1-D2|<=2.


max_day(M) :- M = #max{D : exam_day(E,D), day(D)}, exam(E).
n(T) :- T = #sum{M:max_day(M)}.

#minimize {T:n(T)}.

#maximize {N: exams_acceptable(S,N)}.

% SHOW  
% #show total_exams/1.
% #show exams_bookable/2.
% #show bookable/2.
% #show exams_acceptable/2.
%#show book/2.
#show exam_day/2.
#show exam_room/2.
#show exam_slot/2.
#show acceptable/2.
% #show max_day/1.