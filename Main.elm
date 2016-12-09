module Main exposing (..)


import Util

import Html

import Update exposing (..)
import Model exposing (..)
import View exposing (..)


main = 
  Html.beginnerProgram
    { model  = init
    , view   = view |> Util.bootstrapped
    , update = update
    }
