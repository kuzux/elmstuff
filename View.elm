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

issueIsOpen : Issue -> Bool
issueIsOpen is = is.status /= Closed && is.status /= Wontfix

viewIssue : Issue -> Html Msg 
viewIssue is = 
  let 
    closeIssue id = (ChangeStatus id Closed)
  in
    li [] [ p [] [ (toString is.id) ++ ": " ++ is.name |> text
      , btn Warning "Close" (closeIssue is.id) 
      ] ]

fst : (a, b) -> a
fst (a, _) = a

view : Model -> Html Msg
view model = 
  let
    updateFilter str = (FilterTitle str) |> FilterIssues
    filterForm = Bootstrap.form InlineForm [ TextInput "filter: " updateFilter ]
    issues = [ ul [] (A.filter issueIsOpen model.issues |> A.map viewIssue |> A.toList |> L.reverse ) ]
    newIssueForm = Bootstrap.form InlineForm [ TextInput "issue name: " UpdateIssueName 
      , SubmitButton DefaultBtn "New Issue" (model.newIssueText |> AddIssue)
      ]
  in
    [ filterForm ] ++ issues ++ [ newIssueForm ] |> div []
