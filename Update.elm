module Update exposing (..)

import Array as A
import Maybe as M

import Model exposing (..)

type Msg = 
    Increment Int 
  | Decrement Int 
  | AddCounter
  | RemoveCounter

update : Msg -> Model -> Model
update msg prev = 
  let 
    nth n = A.get n prev.counts |> M.withDefault 0
  in
    case msg of
      Increment n -> 
        { prev | 
          counts = A.set n (nth n + 1) prev.counts }
      Decrement n ->
        { prev | 
          counts = A.set n (nth n - 1 |> Basics.max 0) prev.counts }
      AddCounter ->
        { prev | 
          numCounters = prev.numCounters + 1
        , counts = A.push 0 prev.counts
        }
      RemoveCounter ->
        if prev.numCounters == 0 
        then prev
        else { prev | 
          numCounters = prev.numCounters - 1
        , counts = A.slice 0 -1 prev.counts
        }