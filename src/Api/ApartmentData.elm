module Api.ApartmentData exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Field as Field
import Misc.Http exposing (HttpError, expectJson)
import Api.BookingData exposing (DateRange)
import Date exposing (toIsoString)
import Shared

getApartment : 
    Shared.Model -> String
    -> { onResponse : Result HttpError Apartment -> msg
    }
    -> Cmd msg
getApartment shared apartmentID options =
    Http.get
        { url = shared.url ++ "/api/apartments/" ++ apartmentID
        , expect = expectJson options.onResponse apartmentDecoder
        }

listApartments :
    Shared.Model ->
    { onResponse : Result HttpError (List Apartment) -> msg
    }
    -> Cmd msg
listApartments model options =
    Http.get
        { url = model.url ++ "/api/apartments"
        , expect = expectJson options.onResponse apartmentListDecoder
        }

getPrice :
    Shared.Model ->
    { onResponse : Result HttpError Price -> msg
    , range : DateRange
    , apartmentid : String
    } ->
    Cmd msg
getPrice shared options =
    let
        body : Encode.Value
        body =
            Encode.object
                [ ("check_in", Encode.string <| toIsoString options.range.check_in)
                , ("check_out", Encode.string <| toIsoString options.range.check_out)
                ]
        cmd : Cmd msg
        cmd =
            Http.post
                { url = shared.url ++ "/api/apartments/" ++ options.apartmentid ++ "/price"
                , body = Http.jsonBody body
                , expect = expectJson options.onResponse priceDecoder
                }
        
    in
    cmd

type alias Apartment =
    { id : String
    , name : String
    , images : List String
    , rate : Float
    }

type alias Price =
    { price : Float, nights : Int }

apartmentDecoder : Decoder Apartment
apartmentDecoder =
    Field.require "id" Decode.string <| \id ->
    Field.require "name" Decode.string <| \name ->
    Field.require "images" (Decode.list Decode.string) <| \images ->
    Field.require "rate" Decode.float <| \rate ->
    Decode.succeed
        { id = id
        , name = name
        , images = images
        , rate = rate
        }

apartmentListDecoder : Decoder (List Apartment)
apartmentListDecoder =
    Decode.list apartmentDecoder

priceDecoder : Decoder Price
priceDecoder =
    Field.require "price" Decode.float <| \price ->
    Field.require "nights" Decode.int <| \nights ->
    Decode.succeed
        { price = price
        , nights = nights
        }
