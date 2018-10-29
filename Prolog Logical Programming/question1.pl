% FIRST PART ()

isSub(A, B):-                   
		string_to_list(A, L1),
		string_to_list(B, L2),
		sublist(L1, L2).

sublist(L1, L2):- checkPre(V, L2), checkSuff(L1, V).  % checkPre genearete prefix while checkSuff generate suffix 

checkPre([], B). 
checkPre([X|A], [X|B]):- checkPre(A, B).

checkSuff(A, A).
checkSuff(A, [Y|B]):- checkSuff(A, B).

% SECOND PART (LONGEST INCREASING SUBSEQUENCE) 
ll(List,Len-List) :- length(List,Len).    % will return the length of the list 
sub_seq(L,R):- 
    findall( S, recursion(L,S), A),       % A is list containing all possible increasing subsequence 
    maplist( ll, A, A_MAP),                % maplist map the list with key as their length   
    keysort( A_MAP, SORTED_A_MAP),           % keysort sort the map AMAP based on the key (which is set as length of list) 
    last( SORTED_A_MAP, _Len-R).            %last return the last List of the sorted map (as sorted will have highest length)


recursion([],[]).                        
recursion([_|L1],L2):- recursion(L1,L2).                        % condition in which element is not included in subsequence 
recursion([A|L1],[A|L2]):- recursion(L1,L2), ( L2=[] ; L2=[B|_], A<B). % checks if adding the element will keep list increasing 

