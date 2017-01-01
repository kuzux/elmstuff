module Api exposing (..)


import Http
import Json.Decode exposing (int, string, array, map, Decoder)
import Json.Decode.Pipeline exposing (..)
import Json.Encode as JS

import Model exposing (Issue, IssueStatus(..))
import Message exposing (Msg(..))


apiUrl : String
apiUrl = "https://ogfym7pe9i.execute-api.us-east-1.amazonaws.com/dev"

fetchAllIssues : Cmd Msg
fetchAllIssues =
    let
        url = apiUrl ++ "/issues/all"
        req = Http.get url (array decodeIssue)
    in 
        Http.send LoadIssues req

addIssue : Issue -> Cmd Msg
addIssue is =
    let
        url = apiUrl ++ "/issues/create"
        obj = encodeIssue is |> Http.jsonBody 
        req = Http.post url obj decodeIssue 
    in
        Http.send (\_ -> Noop) req 

updateIssue : Issue -> Cmd Msg 
updateIssue is =
    let
        url = apiUrl ++ "/issues/update"
        obj = encodeIssue is |> Http.jsonBody 
        req = Http.post url obj decodeIssue 
    in
        Http.send (\_ -> Noop) req

encodeIssue : Issue -> JS.Value
encodeIssue is = 
    let
        encodeStatus st =
            case st of 
                Open -> "open"
                Closed -> "closed"
                Doing -> "doing"
                Wontfix -> "wontfix"
    in
        JS.object [
              ("id", JS.int is.id)
            , ("name", JS.string is.name)
            , ("status", JS.string (encodeStatus is.status))
            ]

decodeIssue : Decoder Issue
decodeIssue = 
    let
        toStatus str =
            case str of 
                "open" -> Open 
                "closed" -> Closed
                "doing" -> Doing
                "wontfix" -> Wontfix 
                _ -> Open
        decodeStatus = 
            map toStatus string 
    in
        decode Issue
            |> required "id" int 
            |> required "name" string
            |> required "status" decodeStatus
