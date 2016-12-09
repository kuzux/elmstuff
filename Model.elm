module Model exposing (..)

import Array as A

type alias Model = 
  { counts : A.Array Int
  , numCounters : Int 
  }

init : (Model, Cmd a)
init = 
  ({ counts = A.fromList [ 0 ]
  , numCounters = 1 
  }, Cmd.none)