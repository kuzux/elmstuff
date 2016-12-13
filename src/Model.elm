module Model exposing (..)

import Array as A
import Navigation as N 
import String as S 


type IssueStatus = Open
  | Doing
  | Closed
  | Wontfix

type alias Issue = 
  { id : Int
  , name : String
  , status : IssueStatus
  }

type FilterState = ShowAll
  | FilterTitle String
  | FilterStatus IssueStatus

allStatuses : List IssueStatus
allStatuses = [ Open, Doing, Closed, Wontfix ]

stringToFilter : String -> FilterState
stringToFilter str =
  case str of
    "" -> ShowAll
    "status:open" -> FilterStatus Open
    "status:closed" -> FilterStatus Closed 
    "status:doing" -> FilterStatus Doing 
    "status:wontfix" -> FilterStatus Wontfix 
    _ -> FilterTitle str

issueIsOpen : Issue -> Bool
issueIsOpen is = is.status /= Closed && is.status /= Wontfix

statusToString : IssueStatus -> String
statusToString st =
  case st of
    Open -> "Open"
    Closed -> "Closed"
    Doing -> "Doing"
    Wontfix -> "Wontfix"

stringToStatus : String -> IssueStatus
stringToStatus str =
  case str of
    "Open" -> Open
    "Closed" -> Closed
    "Doing" -> Doing
    "Wontfix" -> Wontfix
    _ -> Open

type alias IssuesModel = 
  { issues : A.Array Issue
  , filter : FilterState
  , newIssueText : String
  , error : Maybe String 
  }

type Model = NotFoundPage 
  | IssuesPage IssuesModel 

init : N.Location -> (Model, Cmd a)
init loc = 
  let 
    initModel = { issues = A.fromList [ ]
      ,  filter = ShowAll
      ,  newIssueText = ""
      ,  error = Nothing
      }
    dehash str = case S.uncons str of
      Nothing -> ""
      Just (x, xs) ->
        if x == '#'
        then xs
        else str
  in
    case (dehash loc.hash) of
      "" ->
        (IssuesPage initModel, Cmd.none)
      "/" ->
        (IssuesPage initModel, Cmd.none)
      _ -> 
        (NotFoundPage, Cmd.none)
