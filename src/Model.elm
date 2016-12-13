module Model exposing (..)

import Array as A
import Navigation as N 

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

type alias Model = 
  { issues : A.Array Issue
  , filter : FilterState
  , newIssueText : String
  , error : Maybe String 
  }

init : N.Location -> (Model, Cmd a)
init _ = 
  ({ issues = A.fromList [ ]
  ,  filter = ShowAll
  ,  newIssueText = ""
  ,  error = Nothing
  }, Cmd.none)
