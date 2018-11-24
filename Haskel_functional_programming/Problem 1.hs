import Data.List
import Data.Char
import System.IO

--Find absolute difference between ASCII values of two characters  
absolute_difference_between_characters :: Char -> Char -> Int
absolute_difference_between_characters x y = abs (ord(x)-ord(y))

--First we find the absolute difference pairwise between two arrays namely x and y(reverse of x). 
-- Then we sum this resulting array of difference and finally we divide this by two.
find_min_operations :: [Char] -> Int
find_min_operations x = sum (zipWith (absolute_difference_between_characters) x y) `div` 2
                        where y = reverse x

--Main function
main = do
    --Enter Input
    putStrLn "Enter the string to check: "
    input <- getLine 
    --Print answer
    putStrLn ("Minimum number of operations required to convert the input string to a palindrome: ")
    --Calculate answer
    print(find_min_operations input)
