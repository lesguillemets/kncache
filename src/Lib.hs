{-# LANGUAGE OverloadedStrings #-}
module Lib
    (
        originUrl
    ) where

import Control.Applicative
import qualified Data.ByteString.Lazy.Char8 as BLC
import qualified Data.ByteString.Char8 as BC
import Data.ByteString.Char8 (ByteString)
import Data.Monoid ((<>))
import Data.Attoparsec.ByteString as AB
import Data.Attoparsec.ByteString.Char8 as ABC

type IPAddress = ByteString
type Path = ByteString
type Version = Int

ip :: Parser BC.ByteString
ip = BC.pack . concat <$> many1 digit `sepBy1` char '.'

-- TODO : better considerations
path :: Parser BC.ByteString
path = BC.pack <$> (char '/' *>  (anyChar `manyTill'` char '?'))

version :: Parser Int
version = string "version=" *> (read <$> many1 digit)

originUrl :: Parser Voice
originUrl =
    Voice <$>
         ((skipMany anyChar *> string "http://") *> ip) <*> path <*> version

data Voice = Voice IPAddress Path Version deriving (Show)
toUrl :: Voice -> ByteString
toUrl (Voice addr p v) =
    BC.concat [ "http://"
              , addr
              , p
              , BC.pack . show $ v
              ]
