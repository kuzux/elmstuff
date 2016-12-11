module Tests exposing (..)


import Test exposing (..)
import Expect

import Array as A
import Maybe as M
import Model 
import Update exposing (..)

fst : (a, b) -> a
fst (x, y) = x

all : Test
all =
    let 
        initLoc = {
            href = "",
            host = "",
            hostname = "",
            protocol = "",
            origin = "",
            port_ = "",
            pathname = "",
            search = "",
            hash = "",
            username = "",
            password = ""
        }
        initVal = Model.init initLoc |> fst
        firstCount x = (x |> fst).counts |> A.get 0 |> M.withDefault 0
        numberOfCounters x = (x |> fst).numCounters
    in
        describe "Elmstuff test suite"
            [ describe "Unit tests"
                [ test "Increase counter" <|
                    \() ->
                        Expect.equal (update (Increment 0) initVal |> firstCount) 1
                , test "Decrease counter" <|
                    \() ->
                        Expect.equal (update (Increment 0) initVal |> fst |> update (Decrement 0) |> firstCount) 0
                , test "Fail to decrease counter" <|
                    \() ->
                        Expect.equal (update (Decrement 0) initVal |> firstCount) 0
                , test "Add counter" <|
                    \() ->
                        Expect.equal (update AddCounter initVal |> numberOfCounters) 2
                , test "Remove counter" <|
                    \() ->
                        Expect.equal (update RemoveCounter initVal |> numberOfCounters) 0
                ]
            ]
