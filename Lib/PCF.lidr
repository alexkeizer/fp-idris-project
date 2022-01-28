> module Lib.PCF
>
> import Data.List
  import Lib.Existentials   -- where is that library?

Terms for PCF
-------------

PCF is a simple language that models computing. Its types are as follows.

> data PCFType = PCFBool
>              | PCFNat
>              | (~>) PCFType PCFType
>              | (*) PCFType PCFType
>              | U
>
> infixr 0 ~>
> infixr 0 *

We want our types to be comparable. This definition enforces unique readability.

> implementation Eq PCFType where
>   PCFBool  == PCFBool  = True
>   PCFNat   == PCFNat   = True
>   (a ~> b) == (c ~> d) = a == c && b == d
>   (a * b)  == (c * d)  = a == c && b == d
>   U        == U        = True
>   _        == _        = False

We begin by defining terms. We use de Bruijn indices to representent bound
variables. This is an elegant way to deel with alpha-equivalence.

> Var : Type
> Var = Nat
>
> data PCFTerm = V Var                    -- variables
>              | C PCFTerm PCFTerm        -- composition / application
>              | L PCFType PCFTerm    -- lambda
>              | P PCFTerm PCFTerm        -- pairing
>              | P1 PCFTerm               -- first projection
>              | P2 PCFTerm               -- second projection
>              | T                        -- true
>              | F                        -- false
>              | Zero                     -- zero
>              | Succ PCFTerm             -- successor
>              | Pred PCFTerm             -- predecessor
>              | IsZero PCFTerm
>              | IfThenElse PCFTerm PCFTerm PCFTerm
>              | Y PCFTerm                -- fixpoint / Y-combinator
>              | I                        -- unit value (*)

The Y constructor returns a fixed-point of the given term. It is required to
define functions by recursion. For example, the sum function on PCFNat is
defined recursively.

> sum : PCFTerm
> sum = Y (L (PCFNat ~> (PCFNat ~> PCFNat)) (L PCFNat (L PCFNat (IfThenElse (IsZero (V 0)) (V 1) (Succ (C (C (V 2) (V 1)) (Pred (V 0))))))))

Our goal here is to write a function that returns the type of any closed term

> total typeOfClosed : PCFTerm -> Maybe PCFType

We are now able to define equality for terms. The important case is
lambda-abstraction. We are using de Bruijn indices, which make comparing terms
very easy.

> implementation Eq PCFTerm where
>   V v              == V w              = v == w
>   C m n            == C p q            = m == p && n == q
>   L a m            == L b n            = a == b && m == n

The other cases are just as simple.

<   P m n            == P p q            = m == p && n == q
<   P1 m             == P1 n             = m == n
<   P2 m             == P2 n             = m == n
<   T                == T                = True
<   F                == F                = True
<   Zero             == Zero             = True
<   Succ m           == Succ n           = m == n
<   Pred m           == Pred n           = m == n
<   IsZero m         == IsZero n         = m == n
<   IfThenElse m n p == IfThenElse q r s = m == q && n == r && p == s
<   Y m              == Y n              = m == n
<   I                == I                = True
>   _                == _                = False

In order to define small-step reduction, we must be able to substitute a term
for a variable in another term. The following functions implement this.

> total substitute : PCFTerm -> PCFTerm -> Var -> PCFTerm

When substituting a term inside another, we might need to rename (increase)
free variables. The following function does this.
The depth argument keeps track of how many lambda's have been encoutered.

> total incFreeVar : Nat -> PCFTerm -> PCFTerm
> incFreeVar depth (V v)              = if v < depth
>                                         then (V v)
>                                       else (V (S v))
> incFreeVar depth (L t m)            = L t (incFreeVar (S depth) m)

The other cases are uninteresting, the increment function is just passed on.

< incFreeVar depth (C m n)            = C (incFreeVar depth m) (incFreeVar depth n)
< incFreeVar depth (P m n)            = P (incFreeVar depth m) (incFreeVar depth n)
< incFreeVar depth (P1 m)             = P1 (incFreeVar depth m)
< incFreeVar depth (P2 m)             = P2 (incFreeVar depth m)
< incFreeVar depth T                  = T
< incFreeVar depth F                  = F
< incFreeVar depth Zero               = Zero
< incFreeVar depth (Succ m)           = Succ (incFreeVar depth m)
< incFreeVar depth (Pred m)           = Pred (incFreeVar depth m)
< incFreeVar depth (IsZero m)         = IsZero (incFreeVar depth m)
< incFreeVar depth (IfThenElse p m n) =
<     IfThenElse (incFreeVar depth p) (incFreeVar depth m) (incFreeVar depth n)
< incFreeVar depth (Y m)              = Y (incFreeVar depth m)
< incFreeVar depth I                  = I

The important cases are the variables and lambda-abstractions.

> substitute (V w)              s v = if v == w
>                                         then s
>                                       else (V w)
> substitute (L t m)            s v = L t (substitute m (incFreeVar 0 s) (S v))

All the other cases are straightforward, once again, the substitution is just passed on.

< substitute (C m n)            s v = C (substitute m s v) (substitute n s v)
< substitute (P m n)            s v = P (substitute m s v) (substitute n s v)
< substitute (P1 m)             s v = P1 (substitute m s v)
< substitute (P2 m)             s v = P2 (substitute m s v)
< substitute T                  s v = T
< substitute F                  s v = F
< substitute Zero               s v = Zero
< substitute (Succ m)           s v = Succ (substitute m s v)
< substitute (Pred m)           s v = Pred (substitute m s v)
< substitute (IsZero m)         s v = IsZero (substitute m s v)
< substitute (IfThenElse p m n) s v =
<     IfThenElse (substitute p s v) (substitute m s v) (substitute n s v)
< substitute (Y m)              s v = Y (substitute m s v)
< substitute I                  s v = I


Reduction
---------

We can now define reduction. We begin with small-step reduction. Not all terms
can reduce, it is thus important that the result is of type Maybe PCFTerm.

> total smallStep : PCFTerm -> Maybe PCFTerm
> smallStep (Pred Zero)           = Just Zero
> smallStep (Pred (Succ m))       = Just m
> smallStep (Pred m)              = do n <- smallStep m
>                                      Just (Pred n)
>
> smallStep (IsZero Zero)         = Just T
> smallStep (IsZero (Succ m))     = Just F
> smallStep (IsZero m)            = do n <- smallStep m
>                                      Just (IsZero (n))
>
> smallStep (Succ m)              = do n <- smallStep m
>                                      Just (Succ n)
>
> smallStep (C (L _ m) n)         = Just (substitute m n 0)
> smallStep (C m p)               = do n <- smallStep m
>                                      Just (C n p)
>
> smallStep (P1 (P m _))          = Just m
> smallStep (P2 (P _ n))          = Just n
> smallStep (P1 m)                = do n <- smallStep m
>                                      Just (P1 n)
> smallStep (P2 m)                = do n <- smallStep m
>                                      Just (P2 n)
>
> smallStep (IfThenElse T m _)    = Just m
> smallStep (IfThenElse F _ n)    = Just n
> smallStep (IfThenElse p m n)    = do p' <- smallStep p
>                                      Just (IfThenElse p' m n)
>
> smallStep (Y m)                 = Just (C m (Y m))
>
> smallStep m with (typeOfClosed m, m /= I)
>             _ | (Just U, True)  = Just I
>             _ | _               = Nothing

An important notion is a value, which is a term that cannot be reduced further.

> total isValue : PCFTerm -> Bool
> isValue T        = True
> isValue F        = True
> isValue Zero     = True
> isValue (Succ m) = isValue m
> isValue (P m n)  = True
> isValue (L t m)  = True
> isValue I        = True
> isValue _        = False

Values are exactly the normal forms for small-step reduction, that is, values
are the terms that cannot be reduced further.

By successively applying small-step reductions, terms can reduce to values.
This is the so called big-step reduction.

> partial eval : PCFTerm -> PCFTerm
> eval T                  = T
> eval F                  = F
> eval Zero               = Zero
> eval (P m n)            = (P m n)
> eval (L t m)            = (L t m)
> eval (Pred Zero)        = Zero
> eval (Pred (Succ m))    = m
> eval (Pred m)           = Pred (eval m)
> eval (IsZero Zero)      = T
> eval (IsZero (Succ m))  = F
> eval (IsZero m)         = IsZero (eval m)
> eval (Succ m)           = Succ (eval m)
> eval (C (L t m) n)      = eval (substitute m n 0)
> eval (C m n)            = C (eval m) n
> eval (P1 (P m _))       = eval m
> eval (P2 (P _ n))       = eval n
> eval (P1 m)             = P1 (eval m)
> eval (P2 m)             = P2 (eval m)
> eval (IfThenElse T m _) = eval m
> eval (IfThenElse F _ n) = eval n
> eval (IfThenElse p m n) = eval (IfThenElse (eval p) m n)
> eval (Y m)              = eval (C m (Y m))
> eval m with (typeOfClosed m)
>        _ | Just U       = I


Type Checking
-------------

We are now ready to define a type infering function. Such a function takes as
arguments a context and a term, and return a type if the term is typeable in
the given context, or Nothing otherwise.

> Context : Type
> Context = List PCFType
>
> total typeOf : Context -> PCFTerm -> Maybe PCFType
> typeOf con (V v) with (inBounds v con)
>   typeOf con (V v) | Yes _                     = Just (index v con)
>   typeOf con (V v) | No _                      = Nothing
>
> typeOf con (C m n) with (typeOf con m)
>   typeOf con (C m n) | Just (a ~> b)           = if Just a == typeOf con n
>                                                    then Just b
>                                                  else Nothing
>   typeOf con (C m n) | _                       = Nothing
>
> typeOf con (L t m) with (typeOf (t::con) m)
>   typeOf con (L t m) | Just a                  = Just (t ~> a)
>   typeOf con (L t m) | _                       = Nothing
>
> typeOf con (P m n)                             = (map (*) (typeOf con m)) <*> (typeOf con n)
>
> typeOf con (P1 m) with (typeOf con m)
>   typeOf con (P1 m) | Just (a * b)             = Just a
>   typeOf con (P1 m) | _                        = Nothing
>
> typeOf con (P2 m) with (typeOf con m)
>   typeOf con (P2 m) | Just (a * b)             = Just b
>   typeOf con (P2 m) | _                        = Nothing
>
> typeOf con T                                   = Just PCFBool
>
> typeOf con F                                   = Just PCFBool
>
> typeOf con Zero                                = Just PCFNat
>
> typeOf con (Succ m) with (typeOf con m)
>   typeOf con (Succ m) | Just PCFNat            = Just PCFNat
>   typeOf con (Succ m) | _                      = Nothing
>
> typeOf con (Pred m) with (typeOf con m)
>   typeOf con (Pred m) | Just PCFNat            = Just PCFNat
>   typeOf con (Pred m) | _                      = Nothing
>
> typeOf con (IsZero m) with (typeOf con m)
>   typeOf con (IsZero m) | Just PCFNat          = Just PCFBool
>   typeOf con (IsZero m) | _                    = Nothing
>
> typeOf con (IfThenElse p m n) with (typeOf con p)
>   typeOf con (IfThenElse p m n) | Just PCFBool = let t1 = typeOf con m
>                                                      t2 = typeOf con n
>                                                  in if t1 == t2
>                                                       then t1
>                                                     else Nothing
>   typeOf con (IfThenElse p m n) | _            = Nothing
>
> typeOf con (Y m) with (typeOf con m)
>   typeOf con (Y m) | Just (a ~> b)             = if a == b
>                                                    then Just a
>                                                  else Nothing
>   typeOf con (Y m) | _                         = Nothing
>
> typeOf con I                                   = Just U

We can now infer the type of closed terms.

> typeOfClosed = typeOf []


Values and Normal Forms
-------------

A certain subset of terms are called `values'

> namespace Value
>   public export
>   data PCFValue = T
>                 | F
>                 | Zero
>                 | Succ PCFValue
>                 | I
>                 | P PCFTerm PCFTerm
>                 | L PCFType PCFTerm
>
>   public export
>   fromTerm : PCFTerm -> Maybe PCFValue
>   fromTerm T          = Just T
>   fromTerm F          = Just F
>   fromTerm Zero       = Just Zero
>   fromTerm (Succ t)   = do v <- fromTerm t
>                            Just (Succ v)
>   fromTerm I          = Just I
>   fromTerm (P m n)    = Just (P m n)
>   fromTerm (L t m)    = Just (L t m)
>   fromTerm _          = Nothing
>
>   public export
>   toTerm : PCFValue -> PCFTerm
>   toTerm T          = T
>   toTerm F          = F
>   toTerm Zero       = Zero
>   toTerm (Succ v)   = Succ (toTerm v)
>   toTerm I          = I
>   toTerm (P m n)    = P m n
>   toTerm (L t m)  = L t m

Values correspond exactly to terms that are in normal forms

>   valuesAreNormalForms : (v : PCFValue) -> smallStep (toTerm v) = Nothing
>   valuesAreNormalForms T        = Refl
>   valuesAreNormalForms F        = Refl
>   valuesAreNormalForms Zero     = Refl
>   valuesAreNormalForms (Succ t) = ?succ
>   valuesAreNormalForms I        = Refl
>   valuesAreNormalForms (P m n)  = ?pair
>   valuesAreNormalForms (L t m)  = ?lambda

-- >   normalFormsAreValues : (t : PCFTerm) -> {auto hnf : smallStep t = Nothing} -> exists (\v -> fromTerm t = Just v)
-- >   normalFormsAreValues = ?undefined2
