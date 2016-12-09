module Model exposing (..)

import Array as A

type alias Model = 
  { counts : A.Array Int
  , numCounters : Int 
  }

init : Model
init = 
  { counts = A.fromList [ 0 ]
  , numCounters = 1 
  }