{-# LANGUAGE OverloadedStrings #-}
module Runner where

import Lib

import Shelly
import Data.Monoid
import Data.Text (pack, Text)
import Control.Concurrent.Async (Async(..))

fixMp3 :: Text -> Sh ()
fixMp3 f = run_ "mp3val" [f, "-f", "-nb", "-t"]

handle :: Prelude.FilePath -> Prelude.FilePath -> Voice -> Sh (Async ())
handle saveDir origFile v = do
    new <- not <$> test_e saveLoc
    asyncSh $ if new
       then do
           cp (fromText . pack $ origFile) saveLoc
           (*> echo "done") . fixMp3 . toTextIgnore $ saveLoc
       else echo "skip"
    where
        saveLoc = saveDir </> toFileName v
