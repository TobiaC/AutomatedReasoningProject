
enum EXAMS;
enum STUDENTS;
enum ROOMS;
enum SLOTS;

array[STUDENTS,EXAMS] of 0..1: booking; %% exams booked by each student

array[EXAMS] of var 0..60: exams_days;
array[EXAMS] of var ROOMS: exams_rooms;
array[EXAMS] of var SLOTS: exams_slots;

array[STUDENTS,EXAMS] of var 0..1: acceptable;

var int: total_days = max(exams_days);


predicate at_least_2_days_apart(EXAMS: i, EXAMS: j) = 
    exams_days[j] > exams_days[i]+2;

predicate at_least_2_days_apart(EXAMS: i, EXAMS: j, EXAMS: k) = 
    exams_days[k] > exams_days[j] + 2 /\ 
    exams_days[j] > exams_days[i]+2;


%% days start from 1 (lunedì)
constraint forall(i in EXAMS)(
    exams_days[i]>=1
);


% % cannot have more than one exam in the same day in the same room at the same time
constraint forall(i,j in EXAMS where i != j)(
    if exams_days[i]=exams_days[j] /\ exams_rooms[i]=exams_rooms[j]
    then exams_slots[i]!=exams_slots[j]
    else true
    endif 
);

%% cannot have exams on saturdays and sundays
constraint forall(e in EXAMS)(
    'mod'(exams_days[e],7) != 6 /\
    'mod'(exams_days[e],7) != 0
);


% a student must be able to make at least 3 exams if he/she booked 3 or more exams
% all booked exams if he/she booked less than 3 exams
constraint forall(s in STUDENTS)(
    if count(booking[s,..],1)>=3
    then exists(i,j,k in EXAMS where booking[s,j] = 1 /\ booking[s,k] = 1 /\ booking[s,i]=1)
            (at_least_2_days_apart(i,j,k) /\ acceptable[s,i]=1 /\ acceptable[s,j]=1 /\ acceptable[s,k] = 1)
    else 
        if count(booking[s,..],1)=2
        then exists(i,j in EXAMS where booking[s,j] = 1 /\ booking[s,i]=1)
            (at_least_2_days_apart(i,j) /\ acceptable[s,i]=1 /\ acceptable[s,j]=1)
        else true
        endif
    endif
);


% %%  cannot accept two exams that are less than two days apart
constraint forall(s in STUDENTS, e1 in EXAMS)(
    not exists(e2 in EXAMS where e1!=e2)(
        abs(exams_days[e1]-exams_days[e2])<=2 /\ acceptable[s,e1] = 1 /\ acceptable[s,e2]=1
    )
);

% any exam that can be booked by a student is an acceptable exam for that student (even if the student did't plan to do that exam)
constraint forall(s in STUDENTS,e1 in EXAMS)(
    if forall(e2 in EXAMS where e1!=e2 /\ acceptable[s,e2]=1)(
            abs(exams_days[e2]-exams_days[e1])>2
            ) 
    then acceptable[s,e1]=1
    else acceptable[s,e1]=0
    endif
    );

var int: v = sum(s in STUDENTS, e in EXAMS)(acceptable[s,e]=1);

% SOLVING --------------------------------------------------------

solve:: int_search(
    exams_days,
    most_constrained,
    indomain_min,
    complete 
)
minimize(total_days);


% OUTPUT -------------------------------------------------

output ["GIORNO"++"\n"] ++ [ show(exams_days[i]) ++ "      " ++show(i) ++ "\n" |
         i in EXAMS] ++ ["\n"] ++ 
         ["AULA"++"\n"] ++ [ show(exams_rooms[i]) ++ "      " ++show(i) ++ "\n" |
         i in EXAMS] ++ ["\n"] ++ 
         ["SLOT"++"\n"] ++ [ show(exams_slots[i]) ++ "      " ++show(i) ++ "\n" |
         i in EXAMS] ++ ["\n"] ++
         ["ACCEPTABLE"++"\n"] ++ [show(acceptable[i,j]) ++ "      " ++ if j=length(EXAMS) then"\n" else " " endif|
         i in STUDENTS, j in EXAMS] ++ ["\n"];


