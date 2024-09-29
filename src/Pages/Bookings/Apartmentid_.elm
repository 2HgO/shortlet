module Pages.Bookings.Apartmentid_ exposing (page, Model, Msg)


import Html.Styled exposing (..)
import View as V
import Page exposing (Page)
import Components.Header
import Components.Hero
import Components.Booking exposing (Msg(..), FormField(..))
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..))
import Api.BookingData exposing (createBooking, Booking)
import Api.ApartmentData exposing (Apartment)
import Time exposing (Month(..))
import Date
import Api.ApartmentData exposing (getApartment)
import Task

type alias Msg = Components.Booking.Msg

page : {apartmentid : String} -> Page Model Msg
page params =
    Page.element
        { init = init params.apartmentid
        , update = update
        , subscriptions = subscriptions
        , view = view params
        }


-- INIT


type alias Model =
    { booking : Booking
    , apartment : Data Apartment
    , today : Date.Date
    }


init : String -> (Model, Cmd Msg)
init apartmentid =
    ({
      apartment = Loading
    , booking = defaultBooking apartmentid (Date.fromCalendarDate 1970 Jan 1)
    , today = Date.fromCalendarDate 1970 Jan 1
    }
    ,  Cmd.batch 
        [ getApartment apartmentid
            { onResponse = ApartmentApiResponded
            }
        , Date.today |> Task.perform GetToday
    ])


defaultBooking : String -> Date.Date -> Booking
defaultBooking apartmentid defaultDate = 
    { fname = ""
    , lname = ""
    , email = ""
    , apartment_id = apartmentid
    , range = 
        { start_date = defaultDate
        , end_date = defaultDate
        }
    }

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UpdateForm field input ->
            let
                booking = model.booking
                range = booking.range
            in
                case field of
                    Fname ->
                        ({ model | booking = { booking | fname = input } }, Cmd.none)
                    Lname ->
                        ({ model | booking = { booking | lname = input } }, Cmd.none)
                    Email ->
                        ({ model | booking = { booking | email = input } }, Cmd.none)
                    StartDate ->
                        let
                            start_date = Maybe.withDefault model.booking.range.start_date (Result.toMaybe (Date.fromIsoString input))
                            end_date = Date.max start_date model.booking.range.end_date
                        in
                            ({ model | booking = { booking | range = { range | start_date = start_date, end_date = end_date } } }, Cmd.none)
                    EndDate ->
                        let
                            end_date = Maybe.withDefault model.booking.range.end_date (Result.toMaybe (Date.fromIsoString input))
                            start_date = Date.min end_date model.booking.range.start_date
                        in
                            ({ model | booking = { booking | range = { range | start_date = start_date, end_date = end_date } } }, Cmd.none)
        Book ->
            (model
            , createBooking {
                onResponse = BookingApiResponded
                ,  booking = model.booking
            })
        BookingApiResponded (Ok _) ->
            ( { model | booking = defaultBooking model.booking.apartment_id model.booking.range.start_date }
            , Date.today |> Task.perform GetToday
            )
        BookingApiResponded (Err _) ->
            ( model
            , Cmd.none
            )
        ApartmentApiResponded (Ok data) ->
            ( { model | apartment = Success data }
            , Cmd.none
            )
        ApartmentApiResponded (Err _) ->
            ( model
            , Cmd.none
            )
        GetToday today ->
            let
                booking = model.booking
                range = booking.range
            in
                ( { model | today = today, booking = { booking | range = { range | start_date = today, end_date = today } } }
                , Cmd.none
                )
            

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW


view : { apartmentid : String } -> Model -> V.View Msg
view params model =
    toUnstyledView <|
    Components.Header.view <|
        Components.Hero.view <|
            let
                innerView =
                    Components.Booking.view
                        { title = "Booking"
                        , apartment = model.apartment
                        , booking = model.booking
                        , today = model.today
                        , body = []
                        }
            in
                { title = innerView.title
                , apartment = Just params.apartmentid
                , body = innerView.body
                }
