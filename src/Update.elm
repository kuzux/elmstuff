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


route : N.Location -> (Model, Cmd Msg)
route = init

updateIssues : Msg -> Model -> IssuesModel -> (Model, List (Cmd Msg))
updateIssues msg prev isModel =
  let 
    defaultModel x = { prev | page = IssuesPage x }
    noEffect x = (x, [ Cmd.none ])
  in
    case msg of
      AddIssue newName ->
        case A.filter (\is -> is.name == newName) isModel.issues |> A.length of
          0 ->
            { isModel | issues = ({ id = (A.length isModel.issues + 1)
              , name = newName
              , status = Open
              } |> (\i -> A.push i isModel.issues))
            } |> defaultModel |> noEffect
          _ ->
            { isModel | error = Just Tr.UniqueIssueError } |> defaultModel |> noEffect
      ChangeStatus id newStatus -> 
        case A.get (id-1) isModel.issues of
          Nothing ->
            { isModel | error = Just Tr.IssueIdError } |> defaultModel |> noEffect
          Just is ->
            { isModel | issues = A.set (id-1) { is | status = newStatus } isModel.issues } |> defaultModel |> noEffect
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
        {isModel | error = Nothing } |> defaultModel |> noEffect
      ChangeLanguage _ ->
        isModel |> defaultModel |> noEffect

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

    reduceCmds : Cmd Msg -> Cmd Msg -> Cmd Msg
    reduceCmds cmd acc = 
      if acc == Cmd.none
      then cmd
      else if cmd == Cmd.none
        then acc
        else Debug.crash "Can't do that (or simply don't know)"

    reducedCmds : Cmd Msg
    reducedCmds = List.foldl reduceCmds Cmd.none allCmds
  in
    (finalState , reducedCmds)
