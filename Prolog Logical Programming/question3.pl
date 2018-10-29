echo_file() :-
  open('sample_input.txt', read, ID),  % open a stream
  repeat,             % try again forever
  read(ID, X),        % read from the stream
  setinp(X),  % function to encode list list of type
  X == end_of_file,   % fail (backtrack) if not end of file
  close(ID).          % close the file

setinp(X  ):- X == end_of_file.     % will not check of it is end of file 
setinp(X ) :-  atom_chars(X, Cs) ,encode(Cs , L2), open('encoded_output.txt',write,Stream), write(Stream,L2), close(Stream).  
% atom_chars will convert atom into list 
% encode fucntion will retunr encoded list 
% open write and close will write in output file 

encode(L1, L3) :- combine(L1, L) ,rle(L ,L2), strip(L2 , L3).
% combine function will combine consecutive simillar character into one string 
% rle will convert list of simillar charaters into [N , a] where N is number of element and a is the element
% strip will remove list with value of N == 1 

combine([],[]).                                
combine([X|XS] , [Z|ZS]) :- func(X ,XS , YS , Z), combine(YS , ZS).  % combine will mix the consecutive same element togehter in a list

func(X , [] , [] , [X]).  
func(X, [Y|YS] , [Y|YS] , [X]) :- X \= Y.
func(X , [X|XS] , YS ,[X|ZS] ) :- func(X, XS , YS , ZS ). % will combine in list of the element is same 

rle([] , []).
rle([[X|XS] | YS] , [[N, X]|ZS]) :- length([X|XS], N) , rle(YS , ZS).  % will convert list into number , aplhabet pair

strip([], []).
strip([[1,X]|YS],[X|ZS]) :- strip(YS , ZS).
strip([[N,X]|YS],[[N,X]|ZS]) :- N > 1 ,strip(YS , ZS). % if any number aplhabet pair has number 1 then this would make it just character