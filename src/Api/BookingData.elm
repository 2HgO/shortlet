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
                [ ("fname", Encode.string options.booking.fname)
                , ("apartment_id", Encode.string options.booking.apartment_id)
                , ("lname", Encode.string options.booking.lname)
                , ("email", Encode.string options.booking.email)
                , ("range", Encode.object 
                    [ ("start_date", Encode.string <| toIsoString options.booking.range.start_date)
                    , ("end_date", Encode.string <| toIsoString options.booking.range.end_date)
                    ])
                ]
        cmd : Cmd msg
        cmd =
            Http.post
                { url = "http://localhost:55059/api/bookings"
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
    { apartment_id : String
    , fname : String
    , lname : String
    , email : String
    , range : DateRange
    }

type alias DateRange =
    { start_date : Date
    , end_date : Date
    }

bookingRespDecoder : Decoder BookingResp
bookingRespDecoder =
    Field.require "success" Decode.bool <| \success ->
    Field.require "message" Decode.string <| \message ->
    Decode.succeed
        { success = success
        , message = message
        }
