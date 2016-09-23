{-# LANGUAGE OverloadedStrings #-}
module Lib
    (
        originUrl
    ) where

import qualified Data.ByteString.Lazy.Char8 as BLC
import qualified Data.ByteString.Char8 as BC
import Data.Monoid ((<>))
import Data.Attoparsec.ByteString
import Data.Attoparsec.ByteString.Char8

originUrl :: Parser BC.ByteString
originUrl = do
    http <- string "http"
    content <- many' (char '.')
    return $ http <> BC.pack content

