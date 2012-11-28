{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE CPP #-}
#if __GLASGOW_HASKELL__ >= 701
{-# LANGUAGE DefaultSignatures #-}
#endif

module Generics.Deriving.Uniplate (
    Uniplate(..)

  -- * Default definitions
  , childrendefault
  , descenddefault

  ) where


import Generics.Deriving.Base
import Generics.Deriving.Instances ()

--------------------------------------------------------------------------------
-- Generic Uniplate
--------------------------------------------------------------------------------

class Uniplate' f b where
  children'  :: f a -> [b]
  descend'   :: (b -> b) -> f a -> f a
  transform' :: (b -> b) -> f a -> f a

instance Uniplate' U1 a where
  children' U1 = []
  descend' _ U1 = U1
  transform' _ U1 = U1

instance (Uniplate a) => Uniplate' (K1 i a) a where
  children' (K1 a) = [a]
  descend' f (K1 a) = K1 (f a)
  transform' f (K1 a) = K1 (transform f a)

instance Uniplate' (K1 i a) b where
  children' (K1 _) = []
  descend' _ (K1 a) = K1 a
  transform' _ (K1 a) = K1 a

instance (Uniplate' f b) => Uniplate' (M1 i c f) b where
  children' (M1 a) = children' a
  descend' f (M1 a) = M1 (descend' f a)
  transform' f (M1 a) = M1 (transform' f a)

instance (Uniplate' f b, Uniplate' g b) => Uniplate' (f :+: g) b where
  children' (L1 a) = children' a
  children' (R1 a) = children' a
  descend' f (L1 a) = L1 (descend' f a)
  descend' f (R1 a) = R1 (descend' f a)
  transform' f (L1 a) = L1 (transform' f a)
  transform' f (R1 a) = R1 (transform' f a)

instance (Uniplate' f b, Uniplate' g b) => Uniplate' (f :*: g) b where
  children' (a :*: b) = children' a ++ children' b 
  descend' f (a :*: b) = descend' f a :*: descend' f b 
  transform' f (a :*: b) = transform' f a :*: transform' f b


class Uniplate a where 
  children :: a -> [a]
#if __GLASGOW_HASKELL__ >= 701
  default children :: (Generic a, Uniplate' (Rep a) a) => a -> [a]
  children = childrendefault
#endif

  descend :: (a -> a) -> a -> a
#if __GLASGOW_HASKELL__ >= 701
  default descend :: (Generic a, Uniplate' (Rep a) a) => (a -> a) -> a -> a
  descend = descenddefault
#endif

  transform :: (a -> a) -> a -> a
#if __GLASGOW_HASKELL__ >= 701
  default transform :: (Generic a, Uniplate' (Rep a) a) => (a -> a) -> a -> a
  transform = transformdefault
#endif

childrendefault :: (Generic a, Uniplate' (Rep a) a) => a -> [a]
childrendefault = children' . from

descenddefault :: (Generic a, Uniplate' (Rep a) a) => (a -> a) -> a -> a
descenddefault f = to . descend' f . from

transformdefault :: (Generic a, Uniplate' (Rep a) a) => (a -> a) -> a -> a
transformdefault f = f . to . transform' f . from


-- Base types instances
instance Uniplate Bool where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate Char where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate Double where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate Float where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate Int where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate () where
  children _ = []
  descend _ = id
  transform = id

-- Tuple instances
instance Uniplate (b,c) where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate (b,c,d) where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate (b,c,d,e) where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate (b,c,d,e,f) where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate (b,c,d,e,f,g) where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate (b,c,d,e,f,g,h) where
  children _ = []
  descend _ = id
  transform = id

-- Parameterized type instances
instance Uniplate (Maybe a) where
  children _ = []
  descend _ = id
  transform = id
instance Uniplate (Either a b) where
  children _ = []
  descend _ = id
  transform = id

instance Uniplate [a] where
  children []    = []
  children (_:t) = [t]
  descend _ []    = []
  descend f (h:t) = h:f t
  transform _ []    = []
  transform f (h:t) = f (h:transform f t)

