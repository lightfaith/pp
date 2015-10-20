-- IMPORT MUST BE ON SECOND LINE?!?!?!??!?!?!!!!!
import Data.Char


-- are all numbers even?
alleven xs = (xs==[x|x<-xs,mod x 2 == 0])


--power all numbers
power xs n = [x ** n | x<-xs]

--upper()
--Data.Char
upper xs = [toUpper x | x<-xs] 

--common divisors
cd x = [n | n<-[1..x], mod x n == 0]

--is prime?
prime x = (length [n | n<-[2..x-1], mod x n == 0] == 0)
prime2 x = (length (cd x) == 2)

-- - - - - - - - - - - - - -- - - 
--union
union xs ys = xs++ [y|y<-ys, elem y xs == False]

--intersect
intersect xs ys = [x | x<-xs, elem x ys]

--subset (is xs subset of ys?)
subset xs ys = length (union xs ys) == length ys
subset2 xs ys = length(intersect xs ys) == length xs
--complement
complement xs ys = [y | y<-ys, elem y xs == False]

-- - - - - - - - - - - - - -
type Person = String
type Book = String
type Database = [(Person, Book)]

-- data je fce bez parametru, vraci staticke hodnoty
udaje = [("marek", "babicka"), ("jana", "babicka"), ("marek", "bidnici")]

books :: Database -> Person -> [Book]
books d p = [b | (p1, b)<-d, p1==p]

borrowers :: Database -> Book -> [Person]
borrowers d b = [p | (p, b1)<-d, b==b1 ]

borrowed :: Database -> Book -> Bool
borrowed d b = length (borrowers d b) > 0

numBorrowed :: Database -> Book -> Int
numBorrowed d b = length(borrowers d b)

--makeLoan :: Database -> Person -> Book -> Database
--makeLoan d p b = d:(p,b)

--returnLoan :: Database -> Person -> Book -> Database

-- - - - - - - - - - - - - -
-- map :: (a->b)->[a]->[b]
-- map f xs = [f x | x<-xs]

-- fold :: (a->a->a) -> [a] -> a

-- fold (+) [1,2,3] = 6

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
type Pic = [String]
obr :: Pic
--obr = ["--##--","--##--","----##","----##","######","######"]
--obr=["-#-", "--#", "###"]
obr = [
 "          mm###########mmm          ",
 "       m####################m       ",
 "     m#####`'#m m###''''######m     ",
 "    ######*'  '   '   'mm#######    ",
 "  m####'  ,             m'#######m  ",
 " m#### m*' ,'  ;     ,   '########m ",
 " ####### m*   m  |#m  ;  m ######## ",
 "|######### mm#  |####  #m##########|",
 " ###########|  |######m############ ",
 " '##########|  |##################  ",
 "  '#########  |## /##############|  ",
 "    ########|  # |/ m###########    ",
 "     '#######      ###########'     ",
 "       ''''''       '''''''''       "]

-- view je bez parametru a vraci fci!
-- view :: (Pic->IO())
view :: Pic -> IO()
-- kompozice fci, protoze jsou to funkce vracejici funkci
view = putStr . concat . map(++"\n")
-- same as view x = putStr(concat(map(++"\n") x))
-- (putStr.concat.map(++"\n")) obr

flipv xs = reverse xs
fliph xs = [reverse x | x<-xs]
fliph2 xs = map reverse xs

dupv xs = xs++xs
duph xs = [x++x | x<-xs]
duph2 xs ys = zipWith (++) xs ys
-- view (duph2 obr obr)

-- transpose
transpose               :: [[a]] -> [[a]]
transpose []             = []
transpose ([]   : xss)   = transpose xss
transpose ((x:xs) : xss) = (x : [h | (h:_) <- xss]) : transpose (xs : [ t | (_:t) <- xss])

-- rotate
rotateleft :: Pic -> Pic
rotateleft p = flipv(transpose p)
rotateright :: Pic -> Pic
rotateright p = fliph (transpose p)
--rotateright p = transpose (flipv p)


