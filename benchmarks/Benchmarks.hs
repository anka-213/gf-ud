module Main where

import UD2GF
import UDAnnotations
import UDConcepts
import PGF (showExpr)
import Criterion.Main

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

-- Our benchmark harness.
main = do
    env <- myUDEnv
    fullFile <- readFile "upto12eng.conllu"
    let sentences = stanzas $ lines fullFile -- the input string has many sentences
    let labeledSentences = [( unwords $ map udFORM $ udWordLines $ prss str, unlines str) | str <- sentences]
    let benchWithOpts opts = [ bench (show nr) $ nf (bestTrees opts env) sentence | (nr, sentence) <- take 10 labeledSentences]
    defaultMain
        [ bgroup "fast-both" $ benchWithOpts [("fastKeepTrying",""),("fastAllFunsLocal","")]
        , bgroup "fast-allFunsLocal" $ benchWithOpts [("fastAllFunsLocal","")]
        , bgroup "fast-keepTrying" $ benchWithOpts [("fastKeepTrying","")]
        -- , bgroup "slow-both" $ benchWithOpts []
        -- bgroup "fib" [ bench "1"  $ nf (bestTrees [] env) (sentences !! 0)
        --              , bench "2"  $ nf (bestTrees [] env) (sentences !! 1)
        --              , bench "3"  $ nf (bestTrees [] env) (sentences !! 2)
        --             --  , bench "9"  $ whnf fib 9
        --             --  , bench "11" $ whnf fib 11
        --              ]
        ]

bestTrees :: [(String,String)] -> UDEnv -> String -> [String]
bestTrees opts env conll = map exprStr exprs
  where
      exprs = getExprs opts env conll
      exprStr expr = case expr of
        [x] -> showExpr [] x
        _ -> "bestTree: ud2gf failed"
