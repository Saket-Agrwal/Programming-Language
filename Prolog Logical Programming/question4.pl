intNumSequence(NAME , N ) :- NAME == "Lucas" , modifiedluc(N ).       
intNumSequence(NAME , N ) :- NAME == "Fibonacci" , modifiedfib(N).
intNumSequence(NAME , N ) :- NAME == "Tribonacci" , modifiedtri(N). 


% nonvar function is used  distinguish whether number is present 
nterm(NAME , N , F) :- NAME == "Lucas" , nonvar(N),! , luc(N , F).  
nterm(NAME , N , F) :- NAME== "Fibonacci"  , nonvar(N), !, fib(N, F) .
nterm(NAME , N ,F ) :- NAME == "Tribonacci"  , nonvar(N) , !, tri(N, F). 
nterm(NAME , N , F) :- NAME == "Lucas" ,nonvar(F) , luccheck(F ,2 , 1 , 1 ,  N). 
nterm(NAME , N , F) :- NAME== "Fibonacci" , nonvar(F) , fibcheck(F, 1 ,1  , 2,  N) .
nterm(NAME , N ,F ) :- NAME == "Tribonacci" , nonvar(F) , tricheck(F, 0 ,1 ,1  ,2 , N). 

modifiedluc(N) :- luc2(N , F) ,reverse(F, T), write(T). 
modifiedfib(N) :- fib2(N, F),reverse(F, T) , write(T). 
modifiedtri(N) :-  tri2(N ,F),reverse(F, T), write(T). 

reverse(List, Rev) :-
        reverse(List, Rev, []).

reverse([], L, L).
reverse([H|T], L, SoFar) :-
        reverse(T, L, [H|SoFar]).


luccheck(2 , 2 , 1 , 1 , 0 ):- !.     % will check wheter elment belong in series , if yes then which element
luccheck(1 , 2 , 1 , 1 , 1 ):- !.
luccheck(V , V1 , V2 ,N ,F):- V2 == V ,!,  F is N .
luccheck(V , V1 , V2 ,N ,F) :- V2 > V ,! , F is -1. 
luccheck(V , V1 , V2 ,N ,F) :- V2 < V ,T1 is V1 + V2 ,luccheck(V ,V2 , T1 , N +1 , F ). 


fibcheck(0 , 1 , 1 , 2 , 0 ):- !.       % will check wheter elment belong in series , if yes then which element
fibcheck(1 , 1 , 1 , 2 , 1 ):- !.
fibcheck(V , V1 , V2 ,N ,F):- V2 == V ,!, F is N .
fibcheck(V , V1 , V2 ,N ,F) :- V2 > V ,!,  F is -1. 
fibcheck(V , V1 , V2 ,N ,F) :- V2 < V ,T1 is V1 + V2 ,fibcheck(V ,V2 , T1 , N +1 , F ). 


tricheck(0 , 0 , 1, 1 , 2 , 0 ):- !.    % will check wheter elment belong in series , if yes then which element
tricheck(1 , 0 , 1, 1 , 2 , 1 ):- !.
tricheck(V , V1 , V2 , V3 ,N ,F):- V3 == V ,! , F is N .
tricheck(V , V1 , V2 , V3,N ,F) :- V3 > V , !, F is -1. 
tricheck(V , V1 , V2 , V3 ,N ,F) :- V3 < V ,T1 is V1 + V2 +V3 ,tricheck(V ,V2 , V3, T1 , N +1 , F ). 




luc2(0, [2]) :- !.          % fucntion will return entire Lucas series upto nth element
luc2(1, [1,2]) :- !.
luc2(N, [F|F1]) :-
        N > 1,
        N1 is N-1,
        N2 is N-2,
        luc2(N1, F1),
        luc2(N2, F2),
        first(F1 , T1),
        first(F2 , T2),
        F is T1+T2.

fib2(0, [1]) :- !.             % fucntion will return entire fibbonaci series upto nth element
fib2(1, [1,1]) :- !.
fib2(N, [F|F1]) :-
        N > 1,
        N1 is N-1,
        N2 is N-2,
        fib2(N1, F1),
        fib2(N2, F2),
        first(F1 , T1),
        first(F2 , T2),
        F is T1+T2.


tri2(0, [0]) :- !.        % fucntion will return entire Tribonacci series upto nth element
tri2(1, [1,1]) :- !.
tri2(2, [1,1,0]) :- !.
tri2(N, [F|F1]) :-
        N > 1,
        N1 is N-1,
        N2 is N-2,
        N3 is N-3,
        tri2(N1, F1),
        tri2(N2, F2),
        tri2(N3, F3),
        first(F1 , T1),
        first(F2 , T2),
        first(F3 , T3),
        F is T1+T2+T3.

first([X|YS], X ):- !.    % function will give the first element of the list 

luc(0, 2) :- !.       % function to generate nth term in lucas series          
luc(1, 1) :- !.
luc(N, F) :-
        N > 1,
        N1 is N-1,
        N2 is N-2,
        luc(N1, F1),
        luc(N2, F2),
        F is F1+F2.

   
fib(0, 0) :- !.      % function to generate nth term in fibbonaci
fib(1, 1) :- !.
fib(N, F) :-
        N > 1,
        N1 is N-1,
        N2 is N-2,
        fib(N1, F1),
        fib(N2, F2),
        F is F1+F2.


tri(0, 0) :- !.         % function to generate nth term in Tribonacci 
tri(1, 1) :- !.
tri(2, 1) :- !.
tri(N, F) :-
        N > 2,
        N1 is N-1,
        N2 is N-2,
        N3 is N-3,
        tri(N1, F1),
        tri(N2, F2),
        tri(N3, F3),
        F is F1+F2+F3.

