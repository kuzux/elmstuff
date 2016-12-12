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

type alias Model = 
  { issues : A.Array Issue
  , filter : (String, FilterState)
  , newIssueText : String
  }

init : N.Location -> (Model, Cmd a)
init _ = 
  ({ issues = A.fromList [ ]
  ,  filter = ("", ShowAll)
  ,  newIssueText = ""
  }, Cmd.none)
