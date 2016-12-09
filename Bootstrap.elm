module Bootstrap exposing (..)


import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


row : Html a -> Html a
row child =
    div [ class "row" ] [ child ]

type ColType = Xs | Sm | Md | Lg

columnName : ColType -> Int -> String
columnName col num =
  let 
    infix = case col of
      Xs -> "-xs-"
      Sm -> "-sm-"
      Md -> "-md-"
      Lg -> "-lg-"
  in 
    "col" ++ infix ++ (toString num)

col : ColType -> Int -> Html a -> Html a
col typ name child = div [ class (columnName typ name) ] [ child ]

type BtnType = 
    Default
  | Success
  | Info
  | Warning
  | Danger
  | Link

btnName : BtnType -> String
btnName typ = 
  let
    infix = case typ of
      Default -> "-default"
      Success -> "-success"
      Info    -> "-info"
      Warning -> "-warning"
      Danger  -> "-danger"
      Link    -> "-link"
  in
    "btn btn" ++ infix

btn : BtnType -> String -> a -> Html a
btn typ value action = button [ type_ "button", class (btnName typ), onClick action ] [ text value ]
