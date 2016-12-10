module View exposing (..)


import Array as A
import List as L
import Maybe as M

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Bootstrap exposing (..)
import Update exposing (..)
import Model exposing (..)


viewCounter : Int -> Int -> Html Msg
viewCounter i n = div []
  [ btn Default "+" (Increment i)
  , btn Default "-" (Decrement i)
  , text " "
  , text (toString n)
  ] |> Bootstrap.col Xs 12 |> row

view : Model -> Html Msg
view model = 
  let
    indices = L.range 0 (model.numCounters - 1)
    viewOne i = viewCounter i (A.get i model.counts |> M.withDefault 0)
  in
    div [] ((L.map viewOne indices) ++ 
      [ btn Default "Add Counter" AddCounter
      , btn Default "Remove Counter" RemoveCounter
      ])
