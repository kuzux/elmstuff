module Bootstrap exposing (..)


import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List as L
import Char 


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

dismissibleAlert : BtnType -> String -> a -> Html a
dismissibleAlert typ value action =
  let
    infix = case typ of
      Success -> "-success"
      Info    -> "-info"
      Warning -> "-warning"
      Danger  -> "-danger"
      _       -> "-default"
    name = "alert alert" ++ infix
  in
    div [ class name ] [ text value
      , button [type_ "button", class "close", onClick action ] [ text "×"] ]

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

type FormInput a = TextInput String (String -> a)
                 | PasswordInput String (String -> a)
                 | TextArea String (String -> a)
                 | SelectMenu String String (List String) (String -> a)
                 | SubmitButton BtnType String a

form : FormType -> List (FormInput a) -> Html a
form typ xs = 
  let 
    formClass =
      case typ of
        DefaultForm -> ""
        InlineForm -> "form-inline"
        HorizontalForm -> "form-horizontal"

    generateOptionTag active opt = 
      option [ value opt, selected (active == opt) ] [ text opt ]

    showFormInput x =
      case x of
        TextInput name onchange ->
          div [ class "form-group" ] [ label [] [text name]
            , input [ type_ "text", class "form-control", onInput onchange ] []
            ]
        SubmitButton typ name callback ->
          btn typ name callback
        PasswordInput name onchange ->
          div [ class "form-group" ] [ label [] [text name]
            , input [ type_ "password", class "form-control", onInput onchange ] []
            ]
        SelectMenu lbl active options callback ->
          div [ class "form-group" ] [ label [] [text lbl]
            , Html.select [ class "form-control", onInput callback ] (L.map (generateOptionTag active) options)
            ]
        TextArea name onchange ->
          div [ class "form-group" ] [ label [] [text name]
            , textarea [class "form-control", onInput onchange ] []
            ]
  in
    Html.form [ class formClass ] (L.map showFormInput xs)

select : String -> String -> (List String) -> (String -> a) -> Html a
select lbl active options callback =
  let
    generateOptionTag active opt = 
      option [ value opt, selected (active == opt) ] [ text opt ]
  in
    div [ class "form-group" ] [ label [] [text lbl]
      , Html.select [ class "form-control", onInput callback ] (L.map (generateOptionTag active) options)
      ]

textInput : String -> (String -> a) -> Html a
textInput name onchange =
  div [ class "form-group" ] [ label [] [text name]
    , input [ type_ "password", class "form-control", onInput onchange ] []
    ]
