module Main exposing (..)


import Util

import Html

import Update exposing (..)
import Model exposing (..)
import View exposing (..)

subs : Model -> Sub Msg
subs model =
  Sub.none

main = 
  Html.program
    { init          = init
    , view          = view |> Util.bootstrapped
    , update        = update
    , subscriptions = subs
    }
