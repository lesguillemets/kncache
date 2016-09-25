{-# LANGUAGE OverloadedStrings #-}
module Lib where

import Data.ByteString.Char8 (ByteString)
import Data.Char (isDigit)
import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Encoding (decodeUtf8)
import qualified Data.ByteString.Char8 as BC
import Data.Monoid

type IPAddress = ByteString
type Path = ByteString
type Version = Int

data Voice = Voice IPAddress Path Version deriving (Show)
toUrl :: Voice -> ByteString
toUrl (Voice addr p v) =
    BC.concat [ "http://"
              , addr
              , p
              , BC.pack . show $ v
              ]

toFileName :: Voice -> Text
toFileName (Voice ip path v) =
    fname <> ".v" <> version <> ".mp3"
    where
        fname =
            T.takeWhile isDigit . last . T.split (== '/') . decodeUtf8 $ path
        version = T.pack . show $ v
