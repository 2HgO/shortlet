module Api.ApartmentData exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Field as Field
import Misc.Http exposing (HttpError, expectJson)

getApartment : String
    -> { onResponse : Result HttpError Apartment -> msg
    }
    -> Cmd msg
getApartment apartmentID options =
    Http.get
        { url = "http://localhost:55056/api/apartments/" ++ apartmentID
        , expect = expectJson options.onResponse apartmentDecoder
        }

listApartments :
    { onResponse : Result HttpError (List Apartment) -> msg
    }
    -> Cmd msg
listApartments options =
    Http.get
        { url = "http://localhost:55056/api/apartments"
        , expect = expectJson options.onResponse apartmentListDecoder
        }

type alias Apartment =
    { id : String
    , isAvailable : Bool
    , name : String
    , address : String
    , images : List String
    , rate : Float
    }

apartmentDecoder : Decoder Apartment
apartmentDecoder =
    Field.require "id" Decode.string <| \id ->
    Field.require "isAvailable" Decode.bool <| \isAvailable ->
    Field.require "name" Decode.string <| \name ->
    Field.require "address" Decode.string <| \address ->
    Field.require "images" (Decode.list Decode.string) <| \images ->
    Field.require "rate" Decode.float <| \rate ->
    Decode.succeed
        { id = id
        , isAvailable = isAvailable
        , name = name
        , address = address
        , images = images
        , rate = rate
        }

apartmentListDecoder : Decoder (List Apartment)
apartmentListDecoder =
    Decode.list apartmentDecoder
