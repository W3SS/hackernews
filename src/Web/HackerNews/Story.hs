{-# LANGUAGE OverloadedStrings #-}
module Web.HackerNews.Story where

import           Control.Applicative ((<$>), (<*>))
import           Control.Monad       (MonadPlus (mzero))
import           Data.Aeson          (FromJSON (parseJSON), Value (Object),
                                      (.:), (.!=), (.:?))
import           Data.Text           (Text)
import           Data.Time           (UTCTime)

import           Web.HackerNews.Util (fromSeconds)

------------------------------------------------------------------------------
-- | Types
data Story = Story {
    storyBy      :: Text
  , storyId      :: StoryId
  , storyKids    :: [Int]
  , storyScore   :: Int
  , storyTime    :: UTCTime
  , storyTitle   :: Text
  , storyType    :: Text
  , storyUrl     :: Text
  , storyDeleted :: Bool
  } deriving Show

newtype StoryId
  = StoryId Int
  deriving (Show, Eq)

type TopStories = [Int]
type MaxItem    = Int

------------------------------------------------------------------------------
-- | JSON Instances
instance FromJSON Story where
   parseJSON (Object o) =
     Story <$> o .: "by"
           <*> (StoryId <$> o .: "id")
           <*> o .: "kids"
           <*> o .: "score"
           <*> (fromSeconds <$> o .: "time")
           <*> o .: "title"
           <*> o .: "type"
           <*> o .: "url"
           <*> o .:? "deleted" .!= False
   parseJSON _ = mzero

