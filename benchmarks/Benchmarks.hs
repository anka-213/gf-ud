module Main where

import UD2GF
import UDAnnotations
import UDConcepts
import PGF (showExpr)
import Criterion.Main
import Debug.Trace (traceM)

-- The function we're benchmarking.
fib m | m < 0     = error "negative!"
      | otherwise = go m
  where
    go 0 = 0
    go 1 = 1
    go n = go (n-1) + go (n-2)

myUDEnv :: IO UDEnv
myUDEnv = getEnv (path "ShallowParse") "Eng" "Text"
  where path x = "grammars/" ++ x

removeVowels :: String -> String
removeVowels = unwords .  map (onTail $ filter (`notElem` "aiueo")) . words
  where
    onTail f [] = []
    onTail f (x:xs) = x : f xs

shortenSentence :: Int -> String -> String
shortenSentence n str = str
-- shortenSentence n str
--   | length str < n = str
--   | otherwise = take n $ removeVowels str

-- Our benchmark harness.
main = do
    env <- myUDEnv
    fullFile <- readFile "upto12eng.conllu"
    let sentences = stanzas $ lines fullFile -- the input string has many sentences
    traceM $ "Sentences: " ++ show (length sentences)
    let labeledSentences = [(nr, unwords $ map udFORM $ udWordLines $ prss str, unlines str) | (nr, str) <- zip [1..] sentences]
    -- let indicesByTime = [7, 0, 8, 2, 4, 6, 1, 9, 3, 5] -- The indices of the first ten sentences, sorted by time
    -- let indicesByTime = [63,25,103] -- The indices of some of the most costly sentences
    -- let reorderedSentences = map (labeledSentences !!) indicesByTime
    let reorderedSentences = labeledSentences
    let variations =
            [
              ("fast-both", [("fastKeepTrying",""),("fastAllFunsLocal","")])
            , ("fast-allFunsLocal", [("fastAllFunsLocal","")])
            , ("fast-keepTrying", [("fastKeepTrying","")])
            , ("slow-both", [])
            ]
    let benchWithOpts sentence (description, opts) =
            bench description $ nf (bestTrees opts env) sentence
    defaultMain
        [ bgroup (show nr ++ ": " ++ shortenSentence 30 name) $ map (benchWithOpts sentence) variations
        | (nr, name, sentence) <- take 600 reorderedSentences
        ]
        -- [ bgroup "fast-both" $ benchWithOpts [("fastKeepTrying",""),("fastAllFunsLocal","")]
        -- , bgroup "fast-allFunsLocal" $ benchWithOpts [("fastAllFunsLocal","")]
        -- , bgroup "fast-keepTrying" $ benchWithOpts [("fastKeepTrying","")]
        -- , bgroup "slow-both" $ benchWithOpts []
        -- -- bgroup "fib" [ bench "1"  $ nf (bestTrees [] env) (sentences !! 0)
        -- --              , bench "2"  $ nf (bestTrees [] env) (sentences !! 1)
        -- --              , bench "3"  $ nf (bestTrees [] env) (sentences !! 2)
        -- --             --  , bench "9"  $ whnf fib 9
        -- --             --  , bench "11" $ whnf fib 11
        -- --              ]
        -- ]

bestTrees :: [(String,String)] -> UDEnv -> String -> [String]
bestTrees opts env conll = map exprStr exprs
  where
      exprs = getExprs opts env conll
      exprStr expr = case expr of
        [x] -> showExpr [] x
        _ -> "bestTree: ud2gf failed"
