module Init exposing (..)


import Array as A
import Navigation as N 
import String as S 

import Model exposing (..)
import Translate as Tr
import Api
import Message exposing (..)

init : N.Location -> (Model, Cmd Msg)
init loc = 
  let 
    initLang = Tr.English
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
        ({ lang = initLang, page = IssuesPage initModel }, Api.fetchAllMessages)
      "/" ->
        ({ lang = initLang, page = IssuesPage initModel }, Api.fetchAllMessages)
      _ -> 
        ({ lang = initLang, page = NotFoundPage }, Cmd.none)
