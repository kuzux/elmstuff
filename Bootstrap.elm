module Bootstrap exposing (..)


import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List

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
    DefaultBtn
  | Success
  | Info
  | Warning
  | Danger
  | LinkBtn

btnName : BtnType -> String
btnName typ = 
  let
    infix = case typ of
      DefaultBtn -> "-default"
      Success    -> "-success"
      Info       -> "-info"
      Warning    -> "-warning"
      Danger     -> "-danger"
      LinkBtn    -> "-link"
  in
    "btn btn" ++ infix

btn : BtnType -> String -> a -> Html a
btn typ value action = button [ type_ "button", class (btnName typ), onClick action ] [ text value ]

type alias AlertType = BtnType

alert : BtnType -> String -> Html a
alert typ value =
  let
    infix = case typ of
      Success -> "-success"
      Info    -> "-info"
      Warning -> "-warning"
      Danger  -> "-danger"
      _       -> "-default"
    name = "alert alert" ++ infix
  in
    div [ class name ] [ text value ]

jumbotron : List (Html a) -> Html a
jumbotron children = div [class "jumbotron"] children

type BreadcrumbItem = BreadcrumbLink String String | BreadcrumbActive String

breadcrumb : List BreadcrumbItem -> Html a
breadcrumb xs = 
  let
    singleItem x = 
      case x of
        BreadcrumbLink url name -> li [] [a [href url] [text name]]
        BreadcrumbActive name -> li [class "active"] [text name]
  in
    List.map singleItem xs |> ol [class "breadcrumb"]

type FormType = DefaultForm 
              | InlineForm 
              | HorizontalForm

type FormInput = TextInput String 
               | PasswordInput String
               | TextArea String
               | FileInput String
