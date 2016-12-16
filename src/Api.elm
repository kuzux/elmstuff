module Api exposing (..)


import Http
import Json.Decode exposing (int, string, array, map, Decoder)
import Json.Decode.Pipeline exposing (..)

import Model exposing (Issue, IssueStatus(..))
import Message exposing (Msg(..))


apiUrl : String
apiUrl = "https://ogfym7pe9i.execute-api.us-east-1.amazonaws.com/dev"

fetchAllMessages : Cmd Msg
fetchAllMessages =
    let
        url = apiUrl ++ "/issues/all"

        req = Http.get url (array decodeIssue)
    in 
        Http.send LoadIssues req

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
