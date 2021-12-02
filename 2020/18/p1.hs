infixl 5 !+
(!+) = (+)
    
infixl 5 !*
(!*) = (*)

sums = -- my entire input with + substituted with !+ and * substituted with !*

main = putStrLn $ show $ foldl1 (+) sums
