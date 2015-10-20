
import Data.Char

data Expr	= Num Int
			| Add Expr Expr
			| Sub Expr Expr
			| Mul Expr Expr
			| Div Expr Expr
			| Var Char 
			deriving(Eq)



exp1::Expr
exp1 = Add (Num 3) (Mul(Num 5)(Sub (Num 9) (Var 'x')))

eval :: Expr->Int
eval (Num x) = x
eval (Add x y) = eval x + eval y
eval (Sub x y) = eval x - eval y
eval (Mul x y) = eval x * eval y
eval (Div x y) = div (eval x) (eval y)

showExpr :: Expr->String
showExpr x = showExpr2 x ' '

showExpr2 :: Expr->Char->String
showExpr2 (Num x) _ = show x


showExpr2 (Var x) _ = [x]
showExpr2 (Add x y) c = let 
							result = showExpr2 x '+' ++ " + " ++ showExpr2 y '+'
						in
							if c=='/' || c=='*'
							then "("++result++")"
							else result

showExpr2 (Sub x y) c = let 
							result = showExpr2 x '-' ++ " - " ++ showExpr2 y '-'
						in
							if c=='/' || c=='*'
							then "("++result++")"
							else result


showExpr2 (Mul x y) c = let 
							result = showExpr2 x '*' ++ " * " ++ showExpr2 y '*'
						in
							result

showExpr2 (Div x y) c = let 
							result = showExpr2 x '/' ++ " / " ++ showExpr2 y '/'
						in
							result

instance Show Expr where
	show x = showExpr x


deriv :: Expr->Char->Expr
deriv (Num x) _ = Num 0
deriv (Add x y) p = Add (deriv x p) (deriv y p)
deriv (Sub x y) p = Sub (deriv x p) (deriv y p)
deriv (Mul x y) p = Add (Mul x (deriv y p)) (Mul (deriv x p) y)
deriv (Div x y) p = Div (Sub(Mul (deriv x p) y) (Mul x (deriv y p))) (Mul y y)
deriv (Var x) p = if p==x then Num 1 else Num 0


-- - - -  INDEX

input = "In computer science,          functional programming\n is a programming paradigm that\n treats computation    as           the\n evaluati    on of mathematical\tfunctions and avoids state\n and mutable data.    It emphasizes\n the application of functions, in contrast\n to the imperativ    e\n programming style, which emphasizes changes in state."

numberLines t = zip [1..] (lines t)

numberWords l lineNum = [(filter isLetter word, lineNum, wordNum)|(wordNum, word)<-zip [1..] (words l)]

numberElements t = concat [ numberWords x lineNum | (lineNum, x)<-numberLines t]

filterElements t = [(w,l,n)|(w,l,n)<-t,length w>3]

uniq [] y = y
uniq ((w,_,_):xs) y
	| elem w y = uniq xs y
	| otherwise = uniq xs (w:y)


getOneIndex word d = [(l,n) | (w,l,n)<-d, word==w]

index t =
	let 
		procText = filterElements (numberElements t)
	in [(x,getOneIndex x procText) | x<-(uniq procText [])]
		


