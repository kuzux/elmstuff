module View exposing ( view )


import Array as A
import List as L
import Maybe as M

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Bootstrap exposing (..)
import Update exposing (..)
import Model exposing (..)


viewIssue : Issue -> Html Msg 
viewIssue is = 
  let 
    closeIssue id = (ChangeStatus id Closed)
  in
    li [] [ p [] [ (toString is.id) ++ ": " ++ is.name |> text
      , btn Warning "Close" (closeIssue is.id)
      , Bootstrap.form InlineForm [SelectMenu "" (statusToString is.status) (L.map statusToString allStatuses) (\str -> stringToStatus str |> ChangeStatus is.id)]
      ] ]

fst : (a, b) -> a
fst (a, _) = a

view : Model -> Html Msg
view model = 
  let
    matches filter issue = 
      case filter of
        ShowAll -> 
          True
        FilterTitle str ->
          String.contains str issue.name
        FilterStatus status ->
          issue.status == status
    updateFilter str = 
      stringToFilter str |> FilterIssues
    filterIssues is = 
      if model.filter == ShowAll then
        issueIsOpen is
      else
        True
    filterForm = Bootstrap.form InlineForm [ TextInput "filter: " updateFilter ]
    issues = [ ul [] (A.filter filterIssues model.issues |> A.filter (matches model.filter) |> A.map viewIssue |> A.toList |> L.reverse ) ]
    newIssueForm = Bootstrap.form InlineForm [ TextInput "issue name: " UpdateIssueName 
      , SubmitButton DefaultBtn "New Issue" (model.newIssueText |> AddIssue)
      ]
  in
    [ filterForm ] ++ issues ++ [ newIssueForm ] |> div []
