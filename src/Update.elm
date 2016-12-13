module Update exposing (..)

import Array as A
import Maybe as M
import Tuple as T 

import Navigation as N

import Model exposing (..)

type Msg = 
    AddIssue String
  | ChangeStatus Int IssueStatus
  | UpdateIssueName String
  | FilterIssues FilterState 
  | UrlChange N.Location
  | DismissError

route : N.Location -> (Model, Cmd Msg)
route = init

updateIssues : Msg -> IssuesModel -> (IssuesModel, Cmd Msg)
updateIssues msg prev =
  case msg of
    AddIssue newName ->
      case A.filter (\is -> is.name == newName) prev.issues |> A.length of
        0 ->
          ({prev | issues = ({ id = (A.length prev.issues + 1)
            , name = newName
            , status = Open
            } |> (\i -> A.push i prev.issues))
          }, Cmd.none)
        _ ->
          ({ prev | error = Just "An issue with the same name exists." }, Cmd.none)
    ChangeStatus id newStatus -> 
      case A.get (id-1) prev.issues of
        Nothing ->
          ({ prev | error = Just "No issue with that id." }, Cmd.none) -- change to some sort of error
        Just is ->
          ({ prev | issues = A.set (id-1) { is | status = newStatus } prev.issues }, Cmd.none)
    UpdateIssueName newName ->
      ({ prev | newIssueText = newName }, Cmd.none)
    FilterIssues state -> 
      ({ prev | filter = state }, Cmd.none)
    UrlChange _ -> 
      (prev, Cmd.none)
    DismissError ->
      ({ prev | error = Nothing }, Cmd.none)

update404Page : Msg -> (Model, Cmd Msg)
update404Page msg = 
  case msg of
    UrlChange loc ->
      route loc
    _ ->
      (NotFoundPage, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg prev = 
  case prev of
    NotFoundPage ->
      update404Page msg
    IssuesPage isModel ->
      updateIssues msg isModel |> T.mapFirst IssuesPage
