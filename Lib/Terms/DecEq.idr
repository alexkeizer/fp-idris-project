-- !!!
-- !!! THIS FILE IS AUTO-GENERATED, DO NOT MODIFY IT DIRECTLY
-- !!!

module Lib.Terms.DecEq

import Lib.Terms
import public Decidable.Equality

implementation Uninhabited (Symbol.App    = Symbol.Pair  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Pair   = Symbol.App   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Fst    = Symbol.Snd   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Fst    = Symbol.Succ  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Fst    = Symbol.Pred  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Fst    = Symbol.IsZero) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Fst    = Symbol.Y     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Snd    = Symbol.Fst   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Snd    = Symbol.Succ  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Snd    = Symbol.Pred  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Snd    = Symbol.IsZero) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Snd    = Symbol.Y     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Succ   = Symbol.Fst   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Succ   = Symbol.Snd   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Succ   = Symbol.Pred  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Succ   = Symbol.IsZero) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Succ   = Symbol.Y     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Pred   = Symbol.Fst   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Pred   = Symbol.Snd   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Pred   = Symbol.Succ  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Pred   = Symbol.IsZero) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Pred   = Symbol.Y     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.IsZero = Symbol.Fst   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.IsZero = Symbol.Snd   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.IsZero = Symbol.Succ  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.IsZero = Symbol.Pred  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.IsZero = Symbol.Y     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Y      = Symbol.Fst   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Y      = Symbol.Snd   ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Y      = Symbol.Succ  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Y      = Symbol.Pred  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Y      = Symbol.IsZero) where uninhabited Refl impossible
implementation Uninhabited (Symbol.T      = Symbol.F     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.T      = Symbol.Zero  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.T      = Symbol.Unit  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.F      = Symbol.T     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.F      = Symbol.Zero  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.F      = Symbol.Unit  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Zero   = Symbol.T     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Zero   = Symbol.F     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Zero   = Symbol.Unit  ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Unit   = Symbol.T     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Unit   = Symbol.F     ) where uninhabited Refl impossible
implementation Uninhabited (Symbol.Unit   = Symbol.Zero  ) where uninhabited Refl impossible


implementation DecEq (Symbol k) where
  decEq IfElse IfElse = Yes Refl
  decEq App    App    = Yes Refl
  decEq Pair   Pair   = Yes Refl
  decEq Fst    Fst    = Yes Refl
  decEq Snd    Snd    = Yes Refl
  decEq Succ   Succ   = Yes Refl
  decEq Pred   Pred   = Yes Refl
  decEq IsZero IsZero = Yes Refl
  decEq Y      Y      = Yes Refl
  decEq T      T      = Yes Refl
  decEq F      F      = Yes Refl
  decEq Zero   Zero   = Yes Refl
  decEq Unit   Unit   = Yes Refl

  decEq App    Pair   = No absurd
  decEq Pair   App    = No absurd
  decEq Fst    Snd    = No absurd
  decEq Fst    Succ   = No absurd
  decEq Fst    Pred   = No absurd
  decEq Fst    IsZero = No absurd
  decEq Fst    Y      = No absurd
  decEq Snd    Fst    = No absurd
  decEq Snd    Succ   = No absurd
  decEq Snd    Pred   = No absurd
  decEq Snd    IsZero = No absurd
  decEq Snd    Y      = No absurd
  decEq Succ   Fst    = No absurd
  decEq Succ   Snd    = No absurd
  decEq Succ   Pred   = No absurd
  decEq Succ   IsZero = No absurd
  decEq Succ   Y      = No absurd
  decEq Pred   Fst    = No absurd
  decEq Pred   Snd    = No absurd
  decEq Pred   Succ   = No absurd
  decEq Pred   IsZero = No absurd
  decEq Pred   Y      = No absurd
  decEq IsZero Fst    = No absurd
  decEq IsZero Snd    = No absurd
  decEq IsZero Succ   = No absurd
  decEq IsZero Pred   = No absurd
  decEq IsZero Y      = No absurd
  decEq Y      Fst    = No absurd
  decEq Y      Snd    = No absurd
  decEq Y      Succ   = No absurd
  decEq Y      Pred   = No absurd
  decEq Y      IsZero = No absurd
  decEq T      F      = No absurd
  decEq T      Zero   = No absurd
  decEq T      Unit   = No absurd
  decEq F      T      = No absurd
  decEq F      Zero   = No absurd
  decEq F      Unit   = No absurd
  decEq Zero   T      = No absurd
  decEq Zero   F      = No absurd
  decEq Zero   Unit   = No absurd
  decEq Unit   T      = No absurd
  decEq Unit   F      = No absurd
  decEq Unit   Zero   = No absurd
