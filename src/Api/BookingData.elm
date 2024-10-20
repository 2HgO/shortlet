module Api.BookingData exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Json.Decode.Field as Field
import Misc.Http exposing (HttpError, expectJson)
import Date exposing (Date, toIsoString)
import Shared

createBooking :
    Shared.Model ->
    { onResponse : Result HttpError BookingResp -> msg
    , booking : Booking
    }
    -> Cmd msg
createBooking shared options =
    let
        body : Encode.Value
        body =
            Encode.object
                [ ("fname", Encode.string options.booking.fname)
                , ("apartment_id", Encode.string options.booking.apartment_id)
                , ("lname", Encode.string options.booking.lname)
                , ("email", Encode.string options.booking.email)
                , ("phone", Encode.string options.booking.phone)
                , ("idtype", Encode.string <| toRepr options.booking.idtype)
                , ("idnumber", Encode.string options.booking.idnumber)
                , ("idexp", Encode.string <| toIsoString options.booking.idexp)
                , ("range", Encode.object 
                    [ ("check_in", Encode.string <| toIsoString options.booking.range.check_in)
                    , ("check_out", Encode.string <| toIsoString options.booking.range.check_out)
                    ])
                ]
        cmd : Cmd msg
        cmd =
            Http.post
                { url = shared.url ++ "/api/bookings"
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
    , phone : String
    , idtype : IDType
    , idnumber : String
    , idexp : Date
    }

type IDType
    = NIN
    | License
    | VotersCard
    | Passport

toString : IDType -> String
toString type_ =
    case type_ of
    NIN -> "NIN"
    License -> "Driver's License"
    Passport -> "International Passport"
    VotersCard -> "Voter's Card"

toRepr : IDType -> String
toRepr type_ =
    case type_ of
    NIN -> "NIN"
    License -> "License"
    VotersCard -> "VotersCard"
    Passport -> "Passport"
fromRepr : String -> IDType
fromRepr type_ =
    case type_ of
    "NIN" -> NIN
    "License" -> License
    "VotersCard" -> VotersCard
    "Passport" -> Passport
    _ -> NIN

type alias DateRange =
    { check_in : Date
    , check_out : Date
    }

bookingRespDecoder : Decoder BookingResp
bookingRespDecoder =
    Field.require "success" Decode.bool <| \success ->
    Field.require "message" Decode.string <| \message ->
    Decode.succeed
        { success = success
        , message = message
        }
