{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Parsers
import Runner
import Prelude hiding (take)
import Data.Attoparsec.ByteString (parseOnly, endOfInput, skipMany, take)
import Data.Attoparsec.ByteString.Char8 (anyChar)
import qualified Data.ByteString as B
import System.Environment (getArgs)

import Shelly hiding ((</>))
import System.Directory (getHomeDirectory)
import System.FilePath.Posix ((</>))


main :: IO ()
main = do
    files <- getArgs
    home <- getHomeDirectory
    let
        g f = do
            p <- parseOnly  myP <$> B.readFile f
            case p of
                (Left _) -> return ()
                (Right v) -> do
                    shelly $ handle (home </> ".kncache") f v
                    return ()
    mapM_ g files


myP = originWithHeader <* skipMany anyChar <* endOfInput
