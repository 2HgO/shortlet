module Misc.Http exposing (..)

import Http exposing (Expect, expectStringResponse)
import Json.Decode as Decode
import Dict

type HttpError
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Int (Maybe String)
    | BadBody String

expectJson : (Result HttpError a -> msg) -> Decode.Decoder a -> Expect msg
expectJson toMsg decoder =
  expectStringResponse toMsg <|
    \response ->
      case response of
        Http.BadUrl_ url ->
          Err (BadUrl url)

        Http.Timeout_ ->
          Err Timeout

        Http.NetworkError_ ->
          Err NetworkError

        Http.BadStatus_ metadata _ ->
          Err (BadStatus metadata.statusCode (Dict.get "message" metadata.headers))

        Http.GoodStatus_ _ body ->
          case Decode.decodeString decoder body of
            Ok value ->
              Ok value

            Err err ->
              Err (BadBody (Decode.errorToString err))

toUserFriendlyMessage : HttpError -> String
toUserFriendlyMessage httpError =
    case httpError of
        BadUrl _ ->
            -- The URL is malformed, probably caused by a typo
            "This page requested a bad URL"

        Timeout ->
            -- Happens after
            "Request took too long to respond"

        NetworkError ->
            -- Happens if the user is offline or the API isn't online
            "Could not connect to the API"

        BadStatus _ message ->
            -- Connected to the API, but something went wrong
            case message of
            Just m -> m
            Nothing -> "Oops! an error occured"

        BadBody _ ->
            -- Our JSON decoder didn't match what the API sent
            "Unexpected response from API"

type Data value
    = Loading
    | Success value
    | Failure Http.Error
