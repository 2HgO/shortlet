module Api.RateData exposing (..)


import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Field as Field
import Date exposing (Date)
import Time exposing (Month(..))
import Misc.Http exposing (HttpError, expectJson)

listReviews : String
    -> { onResponse : Result HttpError (List Rate) -> msg
    }
    -> Cmd msg
listReviews apartmentID options =
    Http.get
        { url = "http://localhost:55059/api/rates?apartmentID=" ++ apartmentID
        , expect = expectJson options.onResponse reviewListDecoder
        }

type alias Rate =
    { date : Date
    , apartment_id : String
    , rate : Float
    , available : Bool
    }

reviewListDecoder : Decoder (List Rate)
reviewListDecoder =
    Decode.list rateDecoder

rateDecoder : Decoder Rate
rateDecoder =
    Field.require "date" Decode.string <| \date ->
    Field.require "apartment_id" Decode.string <| \apartment_id ->
    Field.require "rate" Decode.float <| \rate ->
    Field.require "available" Decode.bool <| \available ->
    Decode.succeed
        { date = Maybe.withDefault (Date.fromCalendarDate 1970 Jan 1) (Result.toMaybe (Date.fromIsoString date))
        , apartment_id = apartment_id
        , rate = rate
        , available = available
        }
