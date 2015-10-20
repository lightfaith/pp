-- 1+4
square n = n * n

-- call like square 8

-- now some possible definitions of factorial, all same (even speed etc.)
fakt1 n = if n==0 then 1
		  else n * fakt1 (n-1)

fakt2 0 = 1
fakt2 n = n * fakt2 (n-1)

fakt3 0 = 1
fakt3 (n+1) = (n+1) * fakt3 n

fakt4 n | n==0 = 1
		| otherwise = n * fakt4 (n-1)

-- fast Fibonacci
-- tuple
fibStep :: (Int,Int) -> (Int,Int)
fibStep (u,v) = (v,u+v)
fibPair :: Int -> (Int,Int)
fibPair n | n==0 = (0,1)
		  | otherwise = fibStep (fibPair (n-1))
fibo :: Int -> Int
fibo = fst . fibPair

-- greatest common divisor
igcd a b | a==b = a
		 | a>b = igcd (a-b) b
 		 | a<b = igcd (b-a) a

-- lists
--1:2:3:[] :: [Int]
--[1,2,3]  :: [Int]

--list length
--length [] = 0
--length (x:xs) = 1 + length xs

--user defined data types
data Color = Black | White
data Tree a = Leaf a | Node a (Tree a) (Tree a)
--type String = [Char]
type Table a = [(String, a)]




--excercise
--len of list = length
delka :: [a] -> Int
delka [] = 0
delka (_:xs) = delka xs + 1

--merge = ++
spoj :: [a] -> [a] -> [a]
spoj [] x = x
spoj (x:xs) y = x:(spoj xs y)

--merge into list of tuples (ignore more elements) = zip
zyp :: [a] -> [b] -> [(a,b)]
zyp _ [] = []
zyp [] _ = []
zyp (x:xs) (y:ys) = (x,y):(zyp xs ys)
--zyp "abc" [1,2]
------
-- reverse list
rev :: [a]->[a]
rev [] = []
rev (x:xs) = rev xs ++ [x]
--another reverse
rev2 :: [a]->[a]->[a]
rev2 [] y = y
rev2 (x:xs) y = rev2 xs (x:y)
-- rev2 "ABCDEF" ""


-- zipwith
-- (*) [1,2,3] [1,2,3] -> [1,4,9]
zw :: (a->b->c)->[a]->[b]->[c]
zw _ _ [] = []
zw _ [] _ = []
zw op (x:xs) (y:ys) = op x y : zw op xs ys

-- scalar multiplication of 2 vectors
-- tuples?????????
-- scal [-4,-7,-6] [-2,-9,-3] = 89
scal :: [Int] -> [Int] -> Int
scal _ [] = 0
scal [] _ = 0
scal (x:xs) (y:ys) = x*y+scal xs ys

-- cartesian product
cart :: [a]->[b]->[(a,b)]
cart xs ys =  [(x,y) | x<-xs, y<-ys]

-- smallest element (consider input restriction - must be comparable (Ord elements) )
minim a b
	| a>b = b
	| otherwise = a

min :: Ord a => [a] -> a
min xs = foldl1 minim xs

-- another solution
min2 :: (Ord a) => [a] -> a
min2 [] = error "list is empty"
min2 [x] = x
min2 (x:xs)
	| x < minfound = x
	| otherwise = minfound
	where minfound = min2 xs
-- another solution
min3 (x:xs) 
	| xs == [] = x
	| x < min3 xs = x
	| otherwise = min3 xs
-- another solution
min4 [x] = x
min4 (x:y:xs) 
	| x<y = min4 (x:xs)
	| otherwise = min4 (y:xs)

