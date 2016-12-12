module Update exposing (..)

import Array as A
import Maybe as M

import Navigation as N

import Model exposing (..)

type Msg = 
    AddIssue String
  | ChangeStatus Int IssueStatus
  | UpdateIssueName String
  | FilterIssues FilterState 
  | UrlChange N.Location
  | Nop

update : Msg -> Model -> (Model, Cmd Msg)
update msg prev = 
  case msg of
    AddIssue newName ->
      ({prev | issues = ({ id = (A.length prev.issues + 1)
        , name = newName
        , status = Open
        } |> (\i -> A.push i prev.issues))
      }, Cmd.none)
    ChangeStatus id newStatus -> 
      case A.get (id-1) prev.issues of
        Nothing ->
          (prev, Cmd.none) -- change to some sort of error
        Just is ->
          ({ prev | issues = A.set (id-1) { is | status = newStatus } prev.issues }, Cmd.none)
    UpdateIssueName newName ->
      ({ prev | newIssueText = newName }, Cmd.none)
    FilterIssues state -> 
      ({ prev | filter = state }, Cmd.none)
    UrlChange _ -> 
      (prev, Cmd.none)
    Nop -> 
      (prev, Cmd.none)
