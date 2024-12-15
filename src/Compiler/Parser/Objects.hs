{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE OverloadedStrings #-}

module Compiler.Parser.Objects
    ( getText
    , keywords
    , tokenMapping
    , Token(..)
    , RunicToken(..)
    ) where

import Data.Map ( fromList, keys, Map )
import Data.Text ( pack, Text )

{-| 
Represents a token value expected by the Runic Compiler's main
parser state machine.
-}
data Token 
    = Keep
    | On
    | LBrack
    | RBrack
    | Guess
    | For
    | Const
    | Function
    | Return
    | If
    | Then
    | Else
    | System
    | End
    | NewLine
    | Expr Text
    deriving Show

-- | Equality definition for the Token type
instance Eq Token where
    (==) :: Token -> Token -> Bool
    Expr _ == Expr _ = True
    x == y = show x == show y -- Works since only Expr can contain instance-specific text

-- | A token with line number it originated from
data RunicToken a = RunicToken Int a

-- | Extracts the text from an `Expr` Token. 
getText :: Token -> Text
getText (Expr t) = t
getText tok = pack $ show tok

instance Functor RunicToken where
    fmap :: (a -> b) -> RunicToken a -> RunicToken b
    fmap f (RunicToken ln rt) = RunicToken ln $ f rt

{-|
Provides a mapping between keywords in valid Runic syntax and their 
corresponding Token value.
-}
tokenMapping :: Map Text Token
tokenMapping = fromList
    [ ("keep"   , Keep)
    , ("on"     , On)
    , ("["      , LBrack)
    , ("]"      , RBrack)
    , ("guess"  , Guess)
    , ("for"    , For)
    , ("const"  , Const)
    , ("fn"     , Function)
    , ("return" , Return)
    , ("if"     , If)
    , ("then"   , Then)
    , ("else"   , Else)
    , ("system" , System)
    , ("end"    , End)
    ] 
    -- Expr does not have a corresponding keyword. It corresponds to 
    -- expressions that will be parsed for building context for 
    -- solving the system later.

{-|
A list of only the keywords in valid Runic syntax generated from
the text-Token mapping.
-}
keywords :: [Text]
keywords = keys tokenMapping