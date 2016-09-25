{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Parsers
import Prelude hiding (take)
import Data.Attoparsec.ByteString (parseOnly, endOfInput, skipMany, take)
import Data.Attoparsec.ByteString.Char8 (anyChar)
import qualified Data.ByteString as B
import System.Environment (getArgs)


main :: IO ()
main = do
    (f:_) <- getArgs
    print . parseOnly (originWithHeader <* skipMany anyChar <* endOfInput) =<< B.readFile f
