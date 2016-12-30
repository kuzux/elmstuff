module Update exposing (..)

import Array as A
import Maybe as M
import Tuple as T 

import Http
import Navigation as N

import Message exposing (..)
import Model exposing (..)
import Init exposing (..)
import Translate as Tr
import Api 

route : N.Location -> (Model, Cmd Msg)
route = init

updateIssues : Msg -> Model -> IssuesModel -> (Model, List (Cmd Msg))
updateIssues msg prev isModel =
  let 
    defaultModel x = { prev | page = IssuesPage x }
    noEffect x = (x, [ Cmd.none ])
    errorOut err = { isModel | error = Just err } |> defaultModel |> noEffect
    doNothing = isModel |> defaultModel |> noEffect
  in
    case msg of
      AddIssue newName ->
        case A.filter (\is -> is.name == newName) isModel.issues |> A.length of
          0 ->
            let
              addIssue i = A.push i isModel.issues
              newIssue = { id = (A.length isModel.issues + 1)
                , name = newName
                , status = Open
                }
              newIssues = { isModel | issues = newIssue |> addIssue }
            in 
              (newIssues |> defaultModel, [ Api.addIssue newIssue ] )
          _ ->
            errorOut Tr.UniqueIssueError
      ChangeStatus id newStatus -> 
        case A.get (id-1) isModel.issues of
          Nothing ->
            errorOut Tr.IssueIdError
          Just is ->
            let
              updateIssue is = { is | status = newStatus }
              updatedIssue = M.map updateIssue (A.get (id - 1) isModel.issues)
              newIssues = 
                case updatedIssue of
                  Just is ->
                    { isModel | 
                      issues = A.set (id-1) is isModel.issues 
                      }
                  Nothing ->
                    isModel
              effect = 
                case updatedIssue of
                  Just is -> Api.updateIssue is
                  Nothing -> Cmd.none
            in 
              (newIssues |> defaultModel, [ effect ])
      UpdateIssueName newName ->
        { isModel | newIssueText = newName } |> defaultModel |> noEffect
      FilterIssues state -> 
        { isModel | filter = state } |> defaultModel |> noEffect
      LoadIssues (Ok xs) ->
        { isModel | issues = xs } |> defaultModel |> noEffect
      LoadIssues (Err _) ->
        isModel |> defaultModel |> noEffect
      UrlChange loc -> 
        route loc |> T.mapSecond (\x -> [ x ])
      DismissError ->
        { isModel | error = Nothing } |> defaultModel |> noEffect
      ChangeLanguage _ ->
        doNothing
      Noop ->
        doNothing

update404Page : Msg -> Model -> (Model, List (Cmd Msg))
update404Page msg prev = 
  case msg of
    UrlChange loc ->
      route loc |> T.mapSecond (\x -> [ x ])
    _ ->
      (prev, [ Cmd.none ])

updateLanguage : Msg -> Model -> (Model, List (Cmd Msg)) 
updateLanguage msg prev =
  case msg of 
    ChangeLanguage newLang ->
      ({ prev | lang = newLang }, [ Cmd.none ])
    _ ->
      (prev, [ Cmd.none ])

update : Msg -> Model -> (Model, Cmd Msg)
update msg prev = 
  let 
    updatePages : Msg -> Model -> (Model, List (Cmd Msg)) 
    updatePages msg prev = 
      case prev.page of
        NotFoundPage ->
          update404Page msg prev
        IssuesPage isModel ->
          updateIssues msg prev isModel

    foldUpdates : (Msg -> Model -> (Model, List (Cmd Msg))) -> (Model, List (Cmd Msg)) -> (Model, List (Cmd Msg))
    foldUpdates x (st, cmds) =
      let
        (newSt, newEff) = x msg st
      in
        (newSt, newEff ++ cmds)

    updateFns : List (Msg -> Model -> (Model, List (Cmd Msg)))
    updateFns =
      [ updatePages, updateLanguage ]

    initState : (Model, List (Cmd Msg))
    initState = 
      (prev, [])

    (finalState, allCmds) = List.foldl foldUpdates initState updateFns

    reducedCmds : Cmd Msg
    reducedCmds = Cmd.batch allCmds
  in
    (finalState , reducedCmds)
