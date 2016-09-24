{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Data.Attoparsec.ByteString (parse)
import qualified Data.ByteString as B
import System.Environment (getArgs)

main :: IO ()
main = do
    (f:_) <- getArgs
    print . parse originUrl =<< B.readFile f
