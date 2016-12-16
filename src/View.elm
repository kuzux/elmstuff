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
import Translate as Tr
import Message exposing (..)

import Api

viewIssue :  Tr.Language -> Issue -> Html Msg 
viewIssue lang is = 
  let 
    issueText = 
      Tr.IssueText is.id is.name |> Tr.translate lang
    activeStatus =
      statusToString is.status |> Tr.translate lang
    statusStrings = 
      L.map (statusToString >> Tr.translate lang) allStatuses
    updateStatus str = 
      Tr.untranslate lang str |> stringToStatus |> ChangeStatus is.id
  in
    li [] [ p [] [ text issueText
      , Bootstrap.form InlineForm [ SelectMenu "" activeStatus statusStrings updateStatus ]
      ] ]

renderIssues :  Tr.Language -> IssuesModel -> Html Msg
renderIssues lang model =
  let
    errorMessage =
      case model.error of
        Nothing -> div [] []
        Just error -> Bootstrap.dismissibleAlert Danger (error |> Tr.translate lang) DismissError
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
    filterForm = Bootstrap.form InlineForm [ TextInput (Tr.FilterLabel |> Tr.translate lang) updateFilter ]
    issues = ul [] (A.filter filterIssues model.issues 
      |> A.filter (matches model.filter) 
      |> A.map (viewIssue lang)
      |> A.toList 
      |> L.reverse 
      )
    newIssueForm = Bootstrap.form InlineForm [ TextInput (Tr.IssueNameLabel |> Tr.translate lang) UpdateIssueName
      , SubmitButton DefaultBtn (Tr.NewIssueLabel |> Tr.translate lang) (model.newIssueText |> AddIssue)
      ]
  in
    errorMessage :: filterForm :: issues :: [ newIssueForm ] |> div []

render404Page : Tr.Language -> Html Msg
render404Page lang = div [] [ text (Tr.PageNotFound |> Tr.translate lang) ]

view : Model -> Html Msg
view model = 
  case model.page of
    NotFoundPage ->
      render404Page model.lang
    IssuesPage isModel ->
      renderIssues model.lang isModel
