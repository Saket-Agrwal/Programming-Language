import Data.Function

-- Exporing possible dimensions of configuration of bedroom and returning most optimal one.
calc_bed_x :: [Int]->[Int]->Int->[Int]
calc_bed_x quantities local area = 
    if((local!!0)>15)
      then [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    else
      comp global1 global2 quantities
      where 
        global1 = calc_hall_x quantities local area
        global2 = calc_bed_x quantities (take 0 local ++ [(local!!0) + 1,(local!!1) + 1] ++ drop (2) local) area

-- Exporing possible dimensions of configuration of hall and returning most optimal one.
calc_hall_x :: [Int]->[Int]->Int->[Int]
calc_hall_x quantities local area = 
    if((local!!2)>20)
      then [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    else
      comp global1 global2 quantities
      where 
        global1 = calc_kitchen_x quantities local area
        global2 = calc_hall_x quantities (take 2 local ++ [(local!!2) + 1,(local!!3) + 1] ++ drop (4) local) area

-- Exporing possible dimensions of configuration of kitchen and returning most optimal one.
calc_kitchen_x :: [Int]->[Int]->Int->[Int]
calc_kitchen_x quantities local area = 
    if((local!!4)>15)
      then [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    else
      comp global1 global2 quantities
      where 
        global1 = calc_bathroom_x quantities local area
        global2 = calc_kitchen_x quantities (take 4 local ++ [(local!!4) + 1,(local!!5) + 1] ++ drop (6) local) area

-- Exporing possible dimensions of configuration of bathroom and returning most optimal one.
calc_bathroom_x :: [Int]->[Int]->Int->[Int]
calc_bathroom_x quantities local area = 
    if((local!!6)>8)
      then [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    else
      comp global1 global2 quantities
      where 
        global1 = calc_balcony_x quantities local area
        global2 = calc_bathroom_x quantities (take 6 local ++ [(local!!6) + 1,(local!!7) + 1] ++ drop (8) local) area

-- Exporing possible dimensions of configuration of balcony and returning most optimal one.
calc_balcony_x :: [Int]->[Int]->Int->[Int]
calc_balcony_x quantities local area = 
    if((local!!8)>10)
      then [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    else
      comp global1 global2 quantities
      where 
        global1 = calc_garden_x quantities local area
        global2 = calc_balcony_x quantities (take 8 local ++ [(local!!8) + 1,(local!!9) + 1] ++ drop (10) local) area

-- Exporing possible dimensions of configuration of gardens and returning most optimal one.
calc_garden_x :: [Int]->[Int]->Int->[Int]
calc_garden_x quantities local area = 
    if((local!!10)>20)
      then [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    else
      comp global1 global2 quantities
      where 
        global1 = final_check quantities local area
        global2 = calc_garden_x quantities (take 10 local ++ [(local!!10) + 1,(local!!11) + 1]) area

-- checking that the given configuration(int local) satisfies all constraints 
final_check :: [Int]->[Int]->Int->[Int]
final_check quantities local area = 
  if (calc_area quantities local > area)
    then [0,0,0,0,0,0,0,0,0,0,0,0]
  else
    if ((local!!4) * (local!!5) > (local!!2) * (local!!3))
      then [0,0,0,0,0,0,0,0,0,0,0,0]
    else
      if ((local!!4) * (local!!5) > (local!!0) * (local!!1))
        then [0,0,0,0,0,0,0,0,0,0,0,0]
      else
        if ((local!!6) * (local!!7) > (local!!4) * (local!!5) )
          then [0,0,0,0,0,0,0,0,0,0,0,0]
        else
          local


-- compare two answers based on which has better space utilization
comp :: [Int]->[Int]->[Int]->[Int]
comp global1 global2 quantities =
  if(calc_area quantities global1 > calc_area quantities global2)
    then global1
  else
    global2

-- calculate area used for given configuration.
calc_area :: [Int]->[Int]->Int
calc_area quantities local = bedroom_area + hall_area + kitchen_area + bathrooms_area + garden_area + balcony_area 
  where 
    bedroom_area = quantities!!0 * (local!!0) * (local!!1)
    hall_area = quantities!!1 * (local!!2) * (local!!3)
    kitchen_area = quantities!!2 * (local!!4) * (local!!5)
    bathrooms_area = quantities!!3 * (local!!6) * (local!!7)
    garden_area = quantities!!4 * (local!!8) * (local!!9)
    balcony_area = quantities!!5 * (local!!10) * (local!!11)


-- Printing answer
showsArc :: [Int] -> [Int] -> Int -> ShowS
showsArc ans quantities unused_space = showString "Bedroom:" . showString " (" . shows (quantities!!0) . showString ") ". shows (ans!!0) . showString "X" .  shows (ans!!1) . showString ",   " . 
                                       showString "Hall:" . showString " (" . shows (quantities!!1) . showString ") ". shows (ans!!2) . showString "X" .  shows (ans!!3) . showString ",   " . 
                                       showString "Kitchen:" . showString " (" . shows (quantities!!2) . showString ") ". shows (ans!!4) . showString "X" .  shows (ans!!5) . showString ",   " . 
                                       showString "Bathroom:" . showString " (" . shows (quantities!!3) . showString ") ". shows (ans!!6) . showString "X" .  shows (ans!!7) . showString ",   " . 
                                       showString "Balcony:" . showString " (" . shows (quantities!!4) . showString ") ". shows (ans!!8) . showString "X" .  shows (ans!!9) . showString ",   " . 
                                       showString "Garden:" . showString " (" . shows (quantities!!5) . showString ") ". shows (ans!!10) . showString "X" .  shows (ans!!11) . showString ",   " . 
                                       showString "Unused Space:" . shows (unused_space) 


-- To derieve number of kitchen from number of bedrooms
find_kitchen :: Int -> Int
find_kitchen x = ceiling z
    where z = (fromIntegral x) / (fromIntegral 3)

-- main function
main = do
  -- take input - Space available, number of bedrooms, number of halls
  putStrLn "Enter space and the number of bedrooms and halls: "
  line <- getLine
  -- convert to int
  let ints = map (read :: String -> Int) (words line)
  let area = ints!!0
  let number_of_bedroom = ints!!1
  let number_of_hall   = ints!!2
  -- number of kitchen can be derieved from number of bedrooms by applying third condition i.e. There can be one kitchen for up to three bedrooms 
  let number_of_kitchen = find_kitchen number_of_bedroom
  -- Applying forth condition derieves quantities of number of bathrooms i.e  number of bathrooms is one more than the number of bedrooms
  let number_of_bathrooms = number_of_bedroom + 1
  -- Applying 5th condition
  let number_of_garden = 1 
  let number_of_balcony = 1
  -- So, quantities are fixed for each type of component
  let quantities = [number_of_bedroom,number_of_hall,number_of_kitchen,number_of_bathrooms,number_of_garden,number_of_balcony]
  -- minimum dimension for each component for example bedx is length of bedroom whose min value is 10
  let bedx = 10
  let bedy = 10
  let hallx = 15
  let hally = 10
  let kitchenx = 7
  let kitcheny = 5
  let bathroomx = 4
  let bathroomy = 5
  let balconyx = 5
  let balconyy = 5
  let gardenx = 10
  let gardeny = 10
  -- local value
  let local = [bedx, bedy, hallx, hally, kitchenx, kitcheny, bathroomx, bathroomy, balconyx, balconyy, gardenx, gardeny]
  -- final answer
  let ans = calc_bed_x quantities local area 
  -- used space
  let used_space = calc_area quantities ans
  -- unused space
  let unused_space = area - used_space
  -- print answer
  if((ans!!0)>0)
    then print(showsArc ans quantities unused_space [])
  else
    print "Not possible"