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
    ensureDirExists shpDir
    asyncSh $ if new
       then do
           cp' (pack origFile) (toTextIgnore saveLoc)
           (*> echo "done") . fixMp3 . toTextIgnore $ saveLoc
       else echo "skip"
    where
        shpDir = saveDir </> spDir v
        saveLoc = shpDir </> toFileName v

cp' :: Text -> Text -> Sh ()
cp' from to = run_ "cp" [from, to, "--preserve=all"]

ensureDirExists :: Shelly.FilePath -> Sh Shelly.FilePath
ensureDirExists dir = do
    exists <- test_d dir
    if exists
       then absPath dir
       else do
           echo $ "Making a folder " <> toTextIgnore dir
           mkdir dir
           absPath dir

