module Util exposing (..)


import Html exposing (..)
import Html.Attributes exposing (..)


stylesheet : String -> Html a
stylesheet url =
  let
    attrs =
      [ attribute "rel"      "stylesheet"
      , attribute "property" "stylesheet"
      , attribute "href"     url
      ]
  in
    node "link" attrs []

bootstrapUrl : String
bootstrapUrl = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"

bootstrapped : (a -> Html b) -> (a -> Html b)
bootstrapped f = \m -> div [] [stylesheet bootstrapUrl, div [class "container"] [f m]]
