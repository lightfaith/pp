-- STACK
module Stack
--(
--	Stack(St),
--	push,
--	pop,
--	top,
--	show,
--	isEmpty
--)
where
	newtype Stack a = St [a]
	emptyS = St []

	push :: a -> Stack a -> Stack a
	push a (St xs) = St (a:xs)

	pop :: Stack a -> Stack a
	pop (St []) = St([])
	pop (St (x:xs)) = St(xs)

	top :: Stack a -> a
	top (St (x:xs)) = x

	showStack (St xs) = show xs

	isEmpty :: Stack a -> Bool
	isEmpty (St []) = True
	isEmpty (St xs) = False

--	instance Show Stack where
--		show x = showStack x


-- NUMBER LINES IN FILE
--           path      lines
getlines :: String -> [String]
getlines path = 
	do
		args<-getArgs
		content <- readFile(path)
	result<- lines content

