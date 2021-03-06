{-# LANGUAGE OverloadedStrings #-}
module Parsers
    (
        originUrl
      , originWithHeader
    ) where

import Lib
import Control.Applicative
import qualified Data.ByteString.Lazy.Char8 as BLC
import qualified Data.ByteString.Char8 as BC
import Data.ByteString.Char8 (ByteString)
import Data.Attoparsec.ByteString as AB
import Data.Attoparsec.ByteString.Char8 as ABC
import Data.List (intercalate)
import Data.Monoid ((<>))

ip :: Parser BC.ByteString
ip = BC.pack . intercalate "." <$> (many1 digit `sepBy1` char '.')
-- |
-- >>> parseOnly ip . BC.pack $ "127.0.0.1"
-- Right "127.0.0.1"

-- TODO : better considerations
path :: Parser BC.ByteString
path = BC.pack <$> (char '/' *>  (anyChar `manyTill'` char '?'))
-- |
-- >>> parseOnly path . BC.pack $ "/there/is/a/pen?v=3"
-- Right "there/is/a/pen"

version :: Parser Int
version = string "version=" *> (read <$> many1 digit)

originUrl :: Parser Voice
originUrl = Voice <$> (string "http://" *> ip) <*> path <*> version

-- |
-- >>> parseOnly originUrl . BC.pack $ "http://2.1.9.1/p/s/rr/1.mp3?version=8"
-- Right (Voice "2.1.9.1" "p/s/rr/1.mp3" 8)

originWithHeader :: Parser Voice
originWithHeader = originUrl <|> (anyChar *> originWithHeader)
