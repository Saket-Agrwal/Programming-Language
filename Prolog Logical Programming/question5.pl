/* Format */
/* (Bus Number,Source,Destination,Distance,Cost,Arrival Time,Dept Time) */
/* e.g. route('1','3'). */
/* e.g. route('1','5'). */
/* e.g. route('1','4'). */
bus('A','1','2',1,1.1,10,20).
bus('B','1','4',3.5,2.2,20,40).
bus('C','1','3',2.5,3.3,40,70).
bus('D','2','3',1,4.4,70,80).
bus('E','2','5',2.5,5.5,110,160).
bus('F','3','4',1,6.6,160,220).
bus('G','3','5',2.2,7.7,220,290).
bus('H','4','5',1,8.8,290,370).

/*Finding the paths with shortest distance, Cost, Time respectively*/
route(A,B) :- shortestDist(A,B,Path1,Dist1,Cost1,Time1),
              write("Optimal path based on Distance:"),
              write(Path1),nl,
              write("Distance:"),write(Dist1),write(", "),
              write("Cost:"),write(Cost1),write(","),
              write("Time:"),write(Time1),nl,
              shortestCost(A,B,Path2,Dist2,Cost2,Time2),
              write("Optimal path based on Cost:"),
              write(Path2),nl,
              write("Distance:"),write(Dist2),write(", "),
              write("Cost:"),write(Cost2),write(","),
              write("Time:"),write(Time2),nl,
              shortestTime(A,B,Path3,Dist3,Cost3,Time3),
              write("Optimal path based on Time:"),
              write(Path3),nl,
              write("Distance:"),write(Dist3),write(", "),
              write("Cost:"),write(Cost3),write(","),
              write("Time:"),write(Time3),nl.

/*Finding if there is direct edge from X to Y*/
connectedDist(R,X,Y,Len,Cos,Tim) :- bus(R,X,Y,Len,Cos,T1,T2), Tim is T2-T1.

/*Exploring all paths from A to B by taking a intermediate node C*/
travelDist(A,B,P,X,[R|X],Len,Cos,Tim) :- connectedDist(R,A,B,Len,Cos,Tim).
travelDist(A,B,Visited,X,Path,Len,Cos,Tim) :-
       connectedDist(R,A,C,Len1,Cos1,Tim1),           
       C \== B,
       \+member(C,Visited),
       travelDist(C,B,[C|Visited],[R|X],Path,Len2,Cos2,Tim2),
       Len is Len1+Len2,
       Cos is Cos1+Cos2,                     
       Tim is Tim1+Tim2.

/*Finding all paths from A to B*/
pathDist(A,B,Path,Len,Cos,Tim) :- travelDist(A,B,[A],[],Q,Len,Cos,Tim), 
                                  reverse(Q,Path).

/*Function to calculate shortest distance path*/
shortestDist(A,B,Path,Length,Cost,Time) :-
   setof([P,Len,Cos,Tim],pathDist(A,B,P,Len,Cos,Tim),Set),
   Set = [_|_], % fail if empty
   minimalDist(Set,[Path,Length,Cost,Time]). 

/*Finding path with minimum distance among all paths form A to B stored in set*/
minimalDist([F|R],M) :- minDist(R,F,M).
minDist([],M,M).
minDist([[P,Len,Cos,Tim]|R],[_,M,_,_],Min) :- Len < M, !, minDist(R,[P,Len,Cos,Tim],Min). 
minDist([_|R],M,Min) :- minDist(R,M,Min).              


/*Finding if there is direct edge from X to Y*/
connectedCost(R,X,Y,Len,Cos,Tim) :- bus(R,X,Y,Len,Cos,T1,T2), Tim is T2-T1.

/*Exploring all paths from A to B by taking a intermediate node C*/
travelCost(A,B,P,X,[R|X],Len,Cos,Tim) :- connectedCost(R,A,B,Len,Cos,Tim).
travelCost(A,B,Visited,X,Path,Len,Cos,Tim) :-
       connectedCost(R,A,C,Len1,Cos1,Tim1),           
       C \== B,
       \+member(C,Visited),
       travelCost(C,B,[C|Visited],[R|X],Path,Len2,Cos2,Tim2),
       Len is Len1+Len2,
       Cos is Cos1+Cos2,                     
       Tim is Tim1+Tim2.

/*Finding all paths from A to B*/
pathCost(A,B,Path,Len,Cos,Tim) :- travelCost(A,B,[A],[],Q,Len,Cos,Tim), 
                                  reverse(Q,Path).

/*Function to calculate least cost path*/
shortestCost(A,B,Path,Length,Cost,Time) :-
   setof([P,Len,Cos,Tim],pathCost(A,B,P,Len,Cos,Tim),Set),
   Set = [_|_], % fail if empty
   minimalCost(Set,[Path,Length,Cost,Time]). 

/*Finding path with least cost among all paths form A to B stored in set*/
minimalCost([F|R],M) :- minCost(R,F,M).
minCost([],M,M).
minCost([[P,Len,Cos,Tim]|R],[_,_,M,_],Min) :- Cos < M, !, minCost(R,[P,Len,Cos,Tim],Min). 
minCost([_|R],M,Min) :- minCost(R,M,Min).

/*Finding if there is direct edge from X to Y*/
connectedTime(R,X,Y,Len,Cos,Tim) :- bus(R,X,Y,Len,Cos,T1,T2), Tim is T2-T1.

/*Exploring all paths from A to B by taking a intermediate node C*/
travelTime(A,B,P,X,[R|X],Len,Cos,Tim) :- connectedTime(R,A,B,Len,Cos,Tim).
travelTime(A,B,Visited,X,Path,Len,Cos,Tim) :-
       connectedTime(R,A,C,Len1,Cos1,Tim1),           
       C \== B,
       \+member(C,Visited),
       travelTime(C,B,[C|Visited],[R|X],Path,Len2,Cos2,Tim2),
       Len is Len1+Len2,
       Cos is Cos1+Cos2,                     
       Tim is Tim1+Tim2.

/*Finding all paths from A to B*/
pathTime(A,B,Path,Len,Cos,Tim) :- travelTime(A,B,[A],[],Q,Len,Cos,Tim), 
                                  reverse(Q,Path).

/*Function to calculate least time path*/
shortestTime(A,B,Path,Length,Cost,Time) :-
   setof([P,Len,Cos,Tim],pathTime(A,B,P,Len,Cos,Tim),Set),
   Set = [_|_], % fail if empty
   minimalTime(Set,[Path,Length,Cost,Time]). 

/*Finding path with least time among all paths form A to B stored in set*/
minimalTime([F|R],M) :- minTime(R,F,M).
minTime([],M,M).
minTime([[P,Len,Cos,Tim]|R],[_,_,_,M],Min) :- Tim < M, !, minTime(R,[P,Len,Cos,Tim],Min). 
minTime([_|R],M,Min) :- minTime(R,M,Min).