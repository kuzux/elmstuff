module Message exposing (..)


import Array as A
import Http
import Navigation as N

import Model exposing (..)
import Translate as Tr

type Msg = 
    AddIssue String
  | ChangeStatus Int IssueStatus
  | UpdateIssueName String
  | LoadIssues (Result Http.Error (A.Array Issue))
  | FilterIssues FilterState 
  | UrlChange N.Location
  | DismissError
  | ChangeLanguage Tr.Language
  | Noop