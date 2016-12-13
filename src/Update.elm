module Update exposing (..)

import Array as A
import Maybe as M
import Tuple as T 

import Navigation as N

import Model exposing (..)
import Translate as Tr


type Msg = 
    AddIssue String
  | ChangeStatus Int IssueStatus
  | UpdateIssueName String
  | FilterIssues FilterState 
  | UrlChange N.Location
  | DismissError
  | ChangeLanguage Tr.Language

route : N.Location -> (Model, Cmd Msg)
route = init

updateIssues : Msg -> Model -> IssuesModel -> Model
updateIssues msg prev isModel =
  let 
    defaultModel x = { prev | page = IssuesPage x }
  in
    case msg of
      AddIssue newName ->
        case A.filter (\is -> is.name == newName) isModel.issues |> A.length of
          0 ->
            { isModel | issues = ({ id = (A.length isModel.issues + 1)
              , name = newName
              , status = Open
              } |> (\i -> A.push i isModel.issues))
            } |> defaultModel
          _ ->
            { isModel | error = Just Tr.UniqueIssueError } |> defaultModel
      ChangeStatus id newStatus -> 
        case A.get (id-1) isModel.issues of
          Nothing ->
            { isModel | error = Just Tr.IssueIdError } |> defaultModel
          Just is ->
            { isModel | issues = A.set (id-1) { is | status = newStatus } isModel.issues } |> defaultModel
      UpdateIssueName newName ->
        { isModel | newIssueText = newName } |> defaultModel
      FilterIssues state -> 
        { isModel | filter = state } |> defaultModel
      UrlChange loc -> 
        route loc |> T.first
      DismissError ->
        {isModel | error = Nothing } |> defaultModel
      ChangeLanguage _ ->
        isModel |> defaultModel

update404Page : Msg -> Model -> Model
update404Page msg prev = 
  case msg of
    UrlChange loc ->
      route loc |> T.first
    _ ->
      prev

updateLanguage : Msg -> Model -> Model 
updateLanguage msg prev =
  case msg of 
    ChangeLanguage newLang ->
      { prev | lang = newLang }
    _ ->
      prev


update : Msg -> Model -> (Model, Cmd Msg)
update msg prev = 
  let 
    updatePages prev = 
      case prev.page of
        NotFoundPage ->
          update404Page msg prev
        IssuesPage isModel ->
          updateIssues msg prev isModel
  in
    ((prev |> updatePages |> updateLanguage msg), Cmd.none)
