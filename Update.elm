module Update exposing (..)

import Array as A
import Maybe as M

import Navigation as N

import Model exposing (..)

type Msg = 
    Increment Int 
  | Decrement Int 
  | AddCounter
  | RemoveCounter
  | UrlChange N.Location

update : Msg -> Model -> (Model, Cmd Msg)
update msg prev = 
  let 
    nth n = A.get n prev.counts |> M.withDefault 0
  in
    case msg of
      Increment n -> 
        ({ prev | 
          counts = A.set n (nth n + 1) prev.counts }
        , Cmd.none)
      Decrement n ->
        ({ prev | 
          counts = A.set n (nth n - 1 |> Basics.max 0) prev.counts 
        }
        , Cmd.none)
      AddCounter ->
        ({ prev | 
          numCounters = prev.numCounters + 1
        , counts = A.push 0 prev.counts
        }
        , Cmd.none)
      RemoveCounter ->
        if prev.numCounters == 0 
        then (prev, Cmd.none)
        else ({ prev | 
          numCounters = prev.numCounters - 1
        , counts = A.slice 0 -1 prev.counts
        }
        , Cmd.none)
      UrlChange _ -> (prev, Cmd.none)
