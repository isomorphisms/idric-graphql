-- Reference excerpt from upstream src/GraphQL/Internal/API.hs, lines 1-140.
-- Truncated deliberately to the type-level schema nucleus; see _reference.code/SOURCES.tsv.

{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeInType #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_HADDOCK not-home #-}

-- | Description: Define a GraphQL schema with Haskell types
module GraphQL.Internal.API
  ( Object
  , Field
  , Argument
  , Union
  , List
  , Enum
  , GraphQLEnum(..)
  , Interface
  , (:>)(..)
  , Defaultable(..)
  , HasAnnotatedType(..)
  , HasAnnotatedInputType
  , HasObjectDefinition(..)
  , getArgumentDefinition
  , SchemaError(..)
  , nameFromSymbol
  -- | Exported for testing.
  , getFieldDefinition
  , getInterfaceDefinition
  , getAnnotatedInputType
  ) where

import Protolude hiding (Enum, TypeError)

import qualified Data.List.NonEmpty as NonEmpty
import Data.Semigroup as S ((<>))
import GHC.Generics ((:*:)(..))
import GHC.TypeLits (Symbol, KnownSymbol, TypeError, ErrorMessage(..))
import GHC.Types (Type)

import qualified GraphQL.Internal.Schema as Schema
import qualified GraphQL.Internal.Name as Name
import GraphQL.Internal.Name (Name, NameError)
import GraphQL.Internal.API.Enum (GraphQLEnum(..))
import GraphQL.Internal.Output (GraphQLError(..))

-- $setup
-- >>> :set -XDataKinds -XTypeOperators

-- | Argument operator. Can only be used with 'Field'.
--
-- Say we have a @Company@ object that has a field that shows whether
-- someone is an employee, e.g.
--
-- @
--   type Company {
--     hasEmployee(employeeName: String!): String!
--   }
-- @
--
-- Then we might represent that as:
--
-- >>> type Company = Object "Company" '[] '[Argument "employeeName" Text :> Field "hasEmployee" Bool]
--
-- For multiple arguments, simply chain them together with ':>', ending
-- finally with 'Field'. e.g.
--
-- @
--   Argument "foo" String :> Argument "bar" Int :> Field "qux" Int
-- @
data a :> b = a :> b
infixr 8 :>


data Object (name :: Symbol) (interfaces :: [Type]) (fields :: [Type])
data Enum (name :: Symbol) (values :: Type)
data Union (name :: Symbol) (types :: [Type])
data List (elemType :: Type)

-- TODO(tom): AFACIT We can't constrain "fields" to e.g. have at least
-- one field in it - is this a problem?
data Interface (name :: Symbol) (fields :: [Type])
data Field (name :: Symbol) (fieldType :: Type)
data Argument (name :: Symbol) (argType :: Type)


-- | The type-level schema was somehow invalid.
data SchemaError
  = NameError NameError
  | EmptyFieldList
  | EmptyUnion
  deriving (Eq, Show)

instance GraphQLError SchemaError where
  formatError (NameError err) = formatError err
  formatError EmptyFieldList = "Empty field list in type definition"
  formatError EmptyUnion = "Empty object list in union"

nameFromSymbol :: forall (n :: Symbol). KnownSymbol n => Either SchemaError Name
nameFromSymbol = first NameError (Name.nameFromSymbol @n)

-- | Specify a default value for a type in a GraphQL schema.
--
-- GraphQL schema can have default values in certain places. For example,
-- arguments to fields can have default values. Because we cannot lift
-- arbitrary values to the type level, we need some way of getting at those
-- values. This typeclass provides the means.
--
-- To specify a default, implement this typeclass.
--
-- The default implementation is to say that there *is* no default for this
-- type.
class Defaultable a where
  -- | defaultFor returns the value to be used when no value has been given.
  defaultFor :: Name -> Maybe a
  defaultFor _ = empty

instance Defaultable Int32

instance Defaultable Double

instance Defaultable Bool

instance Defaultable Text

instance Defaultable (Maybe a) where
  -- | The default for @Maybe a@ is @Nothing@.
  defaultFor _ = pure Nothing


cons :: a -> [a] -> [a]
cons = (:)

singleton :: a -> NonEmpty a
singleton x = x :| []
