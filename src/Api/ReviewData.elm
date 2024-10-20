module Api.ReviewData exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Field as Field
import Date exposing (Date)
import Time exposing (Month(..))
import Misc.Http exposing (HttpError, expectJson)
import Shared

listReviews :
    Shared.Model -> String
    -> { onResponse : Result HttpError (List Review) -> msg
    }
    -> Cmd msg
listReviews shared apartmentID options =
    Http.get
        { url = shared.url ++ "/api/reviews?apartmentID=" ++ apartmentID
        , expect = expectJson options.onResponse reviewListDecoder
        }

type alias Review =
    { id : String
    , tenant : String
    , apartmentID : String
    , review : String
    , createdAt : Date
    }

reviewListDecoder : Decoder (List Review)
reviewListDecoder =
    Decode.list reviewDecoder

reviewDecoder : Decoder Review
reviewDecoder =
    Field.require "id" Decode.string <| \id ->
    Field.require "tenant" Decode.string <| \tenant ->
    Field.require "apartmentID" Decode.string <| \apartmentID ->
    Field.require "review" Decode.string <| \review ->
    Field.require "createdAt" Decode.string <| \createdAt ->
    Decode.succeed
        { id = id
        , tenant = tenant
        , apartmentID = apartmentID
        , review = review
        , createdAt = Maybe.withDefault (Date.fromCalendarDate 1970 Jan 1) (Result.toMaybe (Date.fromIsoString createdAt))
        }
