module Main exposing (..)


import Util

import Html

import Update exposing (..)
import Model exposing (..)
import View exposing (..)
import Navigation


subs : Model -> Sub Msg
subs model =
  Sub.none

main = 
  Navigation.program UrlChange
    { init          = init
    , view          = view |> Util.bootstrapped
    , update        = update
    , subscriptions = subs
    }
