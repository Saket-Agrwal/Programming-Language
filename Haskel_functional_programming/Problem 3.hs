-- functions that take input as workers salary and output the minimum operations required to equal the salaries.
process :: Int -> [Int] -> Int
process times ints = (sum ints) - times * (minimum ints)

-- main function
main :: IO ()
main = do
  -- Enter size of array
  putStrLn "Enter number of workers: "
  times <- readLn

  -- Enter current worker salary
  putStrLn "Enter workers salary: "
  line <- getLine
  -- convert to int
  let ints = map (read :: String -> Int) (words line)

  -- find minimum number of times the operation is performed.
  let ans = process times ints

  -- Print it
  print(ans)