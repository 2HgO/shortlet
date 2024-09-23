module Api.BookingData exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Json.Decode.Field as Field
import Misc.Http exposing (HttpError, expectJson)
import Date exposing (Date, toIsoString)

createBooking :
    { onResponse : Result HttpError BookingResp -> msg
    , booking : Booking
    }
    -> Cmd msg
createBooking options =
    let
        body : Encode.Value
        body =
            Encode.object
                [ ("startDate", Encode.string <| toIsoString options.booking.startDate)
                , ("endDate", Encode.string <| toIsoString options.booking.endDate)
                , ("fname", Encode.string options.booking.fname)
                , ("lname", Encode.string options.booking.lname)
                , ("email", Encode.string options.booking.email)
                ]
        cmd : Cmd msg
        cmd =
            Http.post
                { url = "http://localhost:55056/api/bookings/" ++ options.booking.id
                , body = Http.jsonBody body
                , expect = expectJson options.onResponse bookingRespDecoder
                }
        
    in
    cmd

type alias BookingResp =
    { success : Bool
    , message : String
    }

type alias Booking =
    { id : String
    , fname : String
    , lname : String
    , email : String
    , startDate : Date
    , endDate : Date
    }

bookingRespDecoder : Decoder BookingResp
bookingRespDecoder =
    Field.require "success" Decode.bool <| \success ->
    Field.require "message" Decode.string <| \message ->
    Decode.succeed
        { success = success
        , message = message
        }
