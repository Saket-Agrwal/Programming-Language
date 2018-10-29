/*Married couples*/
married('Jatin','Payal').
married('Payal','Jatin').
married('Pawan','Sheetal').
married('Sheetal','Pawan').
married('Lucky','Priya').
married('Priya','Lucky').
married('Amit','Suchi').
married('Suchi','Amit').

/*love(A,B) :- A is romantically inclined to B*/
love('Payal','Pawan').
love('Amit','Payal').
love('Lucky','Payal').
love('Jatin','Priya').
love('Suchi','Pawan').

/*checking if X,Y relationship is on the rocks*/
rocks(X,Y)   :- married(X,Y), married(Y,X), love(X,_), love(Y,_), not(love(X,Y)), not(love(Y,X)), not(X=Y), @<(X,Y).
/*checking if X is jealous*/
jealous(X)   :- setof(t,jealousy(X),_).
jealousy(X)  :- love(X,Y), love(Z,Y), not(X=Z).
jealousy(X)  :- married(X,Y), love(Z,Y), not(X=Z).

