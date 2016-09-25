{-# LANGUAGE OverloadedStrings #-}
module Lib where

import Data.ByteString.Char8 (ByteString)
import qualified Data.ByteString.Char8 as BC

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
