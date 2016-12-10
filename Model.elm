module Model exposing (..)

import Array as A
import Navigation as N 


type alias Model = 
  { counts : A.Array Int
  , numCounters : Int 
  }

init : N.Location -> (Model, Cmd a)
init _ = 
  ({ counts = A.fromList [ 0 ]
  , numCounters = 1 
  }, Cmd.none)
