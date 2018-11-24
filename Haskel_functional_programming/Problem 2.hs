import Data.List
import Data.Char
import System.IO

-- function to find number of parathas which can be bought using coupons
find_coupons :: Int -> Int -> Int
find_coupons exchange_rate coupons = 
    -- if exchange rate is zero then return zero
    if( exchange_rate == 0 )
        then 0
    else 
        -- else if exchange_rate is greater than coupons then return 0
        if( exchange_rate > coupons )
            then 0
        -- else increment paratha count and decrese coupons held
        else 1 + find_coupons exchange_rate remaining
            where remaining = coupons - exchange_rate + 1


--Function to find number of parathas which can be bought
find_max_parathas :: Int -> Int -> Int -> Int -> Int
find_max_parathas amount price exchange_rate coupons =
    -- If price if greater than amoun, return 0
    if( price > amount )
        then find_coupons exchange_rate coupons
    else
        -- else increment coupon count , decrease amount and increase count of paratha
        1 + find_max_parathas new_amount price exchange_rate new_coupons
        where new_amount = amount - price
              new_coupons = coupons + 1
             

--Main function
main = do
    -- Take input
    putStrLn "Enter the Initial amount,price of Paratha and the number of coupons required to buy a paratha:"
    line <- getLine
    let ints = map (read :: String -> Int) (words line)
    let amount = ints!!0
    let price = ints!!1
    let exchange_rate = ints!!2
    --Enter output
    putStrLn "Maximum number of aloo paratha the customer can get: "
    print (find_max_parathas amount price exchange_rate 0)