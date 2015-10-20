
--quicksort (not optimized - pivot is first element)
--qs [] = []
--qs (x:xs) = 
--	let ls = filter (<x) xs
--		rs = filter(>=x) xs
--	in qs ls ++ [x] ++ qs rs


type Name=String
type Price=Int
type BarCode=Int
type Database=[(BarCode, Name, Price)]
type TillType= [BarCode]
type BillType= [(Name,Price)]
size :: Int
size = 20

d::Database
d= [(111, "Mleko", 20),(123, "Chleba",25),(555,"Piskoty",35)]
a1 :: TillType
a1 = [111,111,555,123,123]

getElement :: Int->Database->(Name,Price)
getElement barcode db = head [(x,y) | (b,x,y)<-db, b==barcode]

formatElement (x,y) =   let 
							size1 = length x
							size2 = length (show y)
						in x ++ (replicate (size-size1-size2) '.') ++ (show y)

makeBill:: TillType-> BillType
makeBill till = [getElement x d | x<-till]

total :: BillType->String
total bill = let
				t=(sum [y|(_,y)<-bill])
				tl = length (show t)
			in "Total"++(replicate (size-5-tl) '.') ++ (show t)++"\n"

formatBill:: BillType-> String
formatBill bill = 	(concat [((formatElement x)++"\n")|x<-bill])
	++(replicate size '.')++"\n"++(total bill)

produceBill:: TillType-> String
produceBill= formatBill . makeBill

-- - - - - - - - - - - - - - - - - - - - - - - - - - -
--THE QUEST
input = "In computer science,          functional programming is a programming paradigm that treats computation    as           the evaluation of mathematical\tfunctions and avoids state and mutable data.    It emphasizes the application of functions, in contrast to the imperative programming style, which emphasizes changes in state."
--l :: Int
--l = 30

--split by space, leave 'empty' words
-- split input []
--   	 input       tmp    result
split :: String -> String->[String]
split [] t = [t]
split (x:xs) y = if x==' ' || x=='\t' then (y:split xs []) else split xs (y++[x])

--remove empty words
--           input     output
nonempty :: [String]->[String]
nonempty [] = []
nonempty (x:xs) = if x=="" then nonempty xs else [x] ++ nonempty xs


-- count total length of all strings in list
--               input   totallen
linewordslen :: [String]->Int
linewordslen [] = 0
linewordslen (x:xs) = length x + linewordslen xs

--build list  of lists (rows) of String (words)
-- linewords (nonempty(split input [])) 40 [[]]
--            input  maxlen templine    result
linewords :: [String]->Int->[String]->[[String]]
linewords [] _ [] = []
linewords [] _ s = [s]
linewords (x:xs) l s =
	let
		append = if s==[""] then [x] else (s++[x])
	in
		if (length x + linewordslen s + length s) < l
		then linewords (xs) l append
		else [s] ++ linewords (x:xs) l []

-- get string of n spaces
--           num  result
getspaces :: Int->String
getspaces n = replicate (n+1) ' '

--concat words with variable number of spaces
--              input  spdiv sprem result
concatwords :: [String]->Int->Int->String
concatwords [] _ _ = []
concatwords (x:xs) s r 	| r == 0 = x ++ getspaces s ++ concatwords xs s r
						| otherwise = x ++ getspaces (s+1) ++ concatwords xs s (r-1)

--create list of rows from list of lists of words
--               input   maxlen result
prepareline :: [[String]]->Int->[String]
prepareline [] _ = []
prepareline ((xs):ys) l = 
	let 
		wordslen = linewordslen xs
		spacenum = length xs - 1
		divisor = if spacenum == 0 then 1 else spacenum
		spacesperspace = 
			if length ys == 0 
			then 0 --will be incremented 
			else quot (l-wordslen-spacenum) divisor
		remainder = 
			if length ys == 0
			then 0 
			else mod (l-wordslen-spacenum) divisor
	in [concatwords xs spacesperspace remainder] ++ prepareline ys l 

--justify string s to length l
--         input maxlen result
justify :: String->Int->String
justify s l | l<15 = "Length too small..."
			|otherwise = concat (map (++"\n") (prepareline(linewords(nonempty(split s [])) l [[]]) l))
