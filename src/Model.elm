module Model exposing (..)


import Array as A

import Translate as Tr


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

statusToString : IssueStatus -> Tr.AppString
statusToString st =
  case st of
    Open -> Tr.Open
    Closed -> Tr.Closed
    Doing -> Tr.Doing
    Wontfix -> Tr.Wontfix

stringToStatus : Tr.AppString -> IssueStatus
stringToStatus str =
  case str of
    Tr.Open -> Open
    Tr.Closed -> Closed
    Tr.Doing -> Doing
    Tr.Wontfix -> Wontfix
    _ -> Open  -- should never happen

type alias IssuesModel = 
  { issues : A.Array Issue
  , filter : FilterState
  , newIssueText : String
  , error : Maybe Tr.AppString 
  }

type Page = NotFoundPage 
  | IssuesPage IssuesModel 

type alias Model = 
  { lang : Tr.Language
  , page : Page }
