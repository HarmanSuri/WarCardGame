module War (main, deal) where
import Data.List
import Debug.Trace

main :: IO ()
main = do
    putStrLn "Hello, world!"

{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}
    
deal :: [Int] -> [Int]
deal shuf = do
    let p1 = getPlayer1(normalizeDeck shuf)
    let p2 = getPlayer2(normalizeDeck shuf)
    playGame p1 p2 [] False


playGame :: [Int] -> [Int] -> [Int] -> Bool -> [Int]
playGame [] [] warchest _ =
    -- when both players lose all cards at the same time
    denormalizeDeck warchest
playGame p1 [] warchest _ =
    -- when player 1 wins
    denormalizeDeck(p1++reverse(sort warchest))
playGame [] p2 warchest _ =
    -- when player 2 wins
    denormalizeDeck(p2++reverse(sort warchest))
playGame (h1:t1) (h2:t2) warchest False =
    -- regular non-war turn
    if h1 == h2 then
        -- call play game again, with param set to true to indicate a war
        playGame t1 t2 (warchest++[h1]++[h2]) True
    else if h1 > h2 then
        -- when player 1 wins the turn add all cards to their deck
        playGame (t1++reverse(sort(warchest++[h1]++[h2]))) t2 [] False
    else
        -- when player 2 wins the turn add all cards to their deck
        playGame t1 (t2++reverse(sort(warchest++[h1]++[h2]))) [] False
playGame (h1:t1) (h2:t2) warchest True =
    -- during war remove one card from each deck and add it to the warchest
    playGame t1 t2 (reverse(sort(warchest++[h1]++[h2]))) False

-- converts all cards in deck; aces from 1 to 13 so it is the highest card, and shifts all other cards down by 1
normalizeDeck :: [Int] -> [Int]
normalizeDeck [] = []
normalizeDeck deck =
    map normalizeCard deck

-- takes a single card; aces to 13 so it is the highest card, and shifts all other cards down by 1
normalizeCard :: Int -> Int
normalizeCard card =
    if card == 1 then 13
    else card - 1

-- converts all cards in a deck; aces from 13 to 1, and shifts all other cards up by 1
denormalizeDeck :: [Int] -> [Int]
denormalizeDeck [] = []
denormalizeDeck deck =
    map denormalizeCard deck

-- takes a single card; aces from 13 to 1, and shifts all other cards up by 1
denormalizeCard :: Int -> Int
denormalizeCard card =
    if card == 13 then 1
    else card + 1

-- returns player1's deck, every other card starting from the first card
getPlayer1 :: [Int] -> [Int]
getPlayer1 [a] = [a]
getPlayer1 [a, _] = [a]
getPlayer1 (xh:xt) = getPlayer1 (tail xt) ++ [xh]

-- returns player2's deck, every other card starting from the second card
getPlayer2 :: [Int] -> [Int]
getPlayer2 [a] = []
getPlayer2 [_, a] = [a]
getPlayer2 (xh:xt) = getPlayer2 (tail xt) ++ [head xt]