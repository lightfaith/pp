--stack
import System.IO
import Control.Monad

--zipit :: [String]->[([Char],String)]
--zipit lajny = zip ([1..]) lajny


--getlines :: FilePath -> IO() 
--getlines path =
--	do
--		content <- readFile(path)
--		let result = lines content
--		writeFile "text2.txt" (concat ([(x++y)|(x,y)<-zipit result]))
		
--

main = do 
	input <-openFile "text.txt" ReadMode
	output <-openFile "text2.txt" WriteMode
	content <- hGetContents input
	hPutStr output ((unlines . numberit . lines) content)
	putStr "File text2.txt created successfully!"
	hClose input
	hClose output

numberit :: [String]->[String]
numberit xs = [ (show x)++" "++y|(x,y)<-(zip ([1..(length xs)]) xs)]


