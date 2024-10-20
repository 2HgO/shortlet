module Pages.Bookings.Apartmentid_ exposing (page, Model, Msg)

import Html.Styled exposing (..)
import View
import Page exposing (Page)
import Components.Header exposing (view)
import Components.Booking exposing (Msg(..), FormField(..), Notification, NotificationType(..), viewToast)
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..), toUserFriendlyMessage)
import Api.BookingData exposing (createBooking, Booking, IDType(..), fromRepr)
import Api.ApartmentData exposing (Apartment, Price, getApartment, getPrice)
import Time exposing (Month(..))
import Date exposing (Date, fromCalendarDate, today, fromIsoString)
import Task exposing (perform)
import Toast exposing (Tray, render, add, expireOnBlur, tray, config)
import Shared
import Route exposing (Route)
import Effect exposing (Effect, sendCmd)

type alias Msg = Components.Booking.Msg

page : Shared.Model -> Route ({apartmentid : String})  -> Page Model Msg
page shared route =
    Page.new
        { init = init route.params.apartmentid shared
        , update = update shared
        , subscriptions = subscriptions
        , view = view route.params
        }


-- INIT


type alias Model =
    { booking : Booking
    , apartment : Data Apartment
    , today : Date
    , price : Data Price
    , tray : Tray Notification
    }


init : String -> Shared.Model -> () -> (Model, Effect Msg)
init apartmentid shared _ =
    ({
      apartment = Loading
    , booking = defaultBooking apartmentid (fromCalendarDate 1970 Jan 1)
    , today = fromCalendarDate 1970 Jan 1
    , price = Loading
    , tray = tray
    }
    ,  sendCmd <| Cmd.batch 
        [ getApartment shared apartmentid
            { onResponse = ApartmentApiResponded
            }
        , today |> perform GetToday
    ])


defaultBooking : String -> Date -> Booking
defaultBooking apartmentid defaultDate = 
    { fname = ""
    , lname = ""
    , email = ""
    , apartment_id = apartmentid
    , phone = ""
    , idtype = NIN
    , idexp = defaultDate
    , idnumber = ""
    , range = 
        { check_in = defaultDate
        , check_out = defaultDate
        }
    }

-- UPDATE

update : Shared.Model -> Msg -> Model -> (Model, Effect Msg)
update shared msg model =
    case msg of
        UpdateForm field input ->
            let
                booking = model.booking
                range = booking.range
            in
                case field of
                    Fname ->
                        ({ model | booking = { booking | fname = input } }, Effect.none)
                    Lname ->
                        ({ model | booking = { booking | lname = input } }, Effect.none)
                    Email ->
                        ({ model | booking = { booking | email = input } }, Effect.none)
                    Phone ->
                        ({ model | booking = { booking | phone = input } }, Effect.none)
                    ID ->
                        ({ model | booking = { booking | idtype = fromRepr input } }, Effect.none)
                    IDExp ->
                        ({ model | booking = { booking | idexp = Maybe.withDefault model.booking.idexp (Result.toMaybe (fromIsoString input)) } }, Effect.none)
                    IDNumber ->
                        ({ model | booking = { booking | idnumber = input } }, Effect.none)
                    StartDate ->
                        let
                            start_date = Maybe.withDefault model.booking.range.check_in (Result.toMaybe (fromIsoString input))
                            end_date = Date.max (Date.add Date.Days 1 start_date) model.booking.range.check_out
                            updated_booking = { booking | range = { range | check_in = start_date, check_out = end_date } }
                        in
                            ({ model | booking = updated_booking },
                            sendCmd <| getPrice shared {
                                onResponse = PriceApiResponded
                                , apartmentid = updated_booking.apartment_id
                                , range = updated_booking.range
                            })
                    EndDate ->
                        let
                            end_date = Maybe.withDefault model.booking.range.check_out (Result.toMaybe (fromIsoString input))
                            start_date = Date.min end_date model.booking.range.check_in
                            updated_booking = { booking | range = { range | check_in = start_date, check_out = Date.max end_date (Date.add Date.Days 1 start_date) } }
                        in
                            ({ model | booking = updated_booking }, 
                            sendCmd <| getPrice shared {
                                onResponse = PriceApiResponded
                                , apartmentid = updated_booking.apartment_id
                                , range = updated_booking.range
                            })
        Book ->
            (model
            , sendCmd <| createBooking shared {
                onResponse = BookingApiResponded
                ,  booking = model.booking
            })
        BookingApiResponded (Ok resp) ->
            let
                notification = { type_ = if resp.success then SUCCESS else ERROR, message = resp.message }
                ( tray, mesg ) = add model.tray (expireOnBlur 5000 notification)
                -- booking = if resp.success then defaultBooking model.booking.apartment_id model.booking.range.check_in else model.booking
                booking = model.booking
            in
                ({ model | tray = tray, booking = booking }, sendCmd <| Cmd.map ToastMsg mesg)
        BookingApiResponded (Err err) ->
            let
                notification = { type_ = ERROR, message = toUserFriendlyMessage err }
                ( tray, mesg ) = add model.tray (expireOnBlur 5000 notification)
            in
                ({ model | tray = tray }, sendCmd <| Cmd.map ToastMsg mesg)
        ApartmentApiResponded (Ok data) ->
            ( { model | apartment = Success data }
            , sendCmd <| getPrice shared {
                onResponse = PriceApiResponded
                , apartmentid = data.id
                , range = model.booking.range
            })
        ApartmentApiResponded (Err err) ->
            ( { model | apartment = Failure err }
            , Effect.none
            )
        PriceApiResponded (Ok data) ->
            ( { model | price = Success data }
            , Effect.none
            )
        PriceApiResponded (Err _) ->
            ( model
            , Effect.none
            )
        GetToday today ->
            let
                booking = model.booking
                range = booking.range
            in
                ( { model | today = today, booking = { booking | range = { range | check_in = today, check_out = Date.add Date.Days 1 today }, idexp = today } }
                , Effect.none
                )
        ToastMsg mesg ->
            let
                ( tray, newMesg ) = Toast.update mesg model.tray
            in  
                ({ model | tray = tray }, sendCmd <| Cmd.map ToastMsg newMesg)
            

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW


view : { apartmentid : String } -> Model -> View.View Msg
view _ model =
    toUnstyledView <|
        Components.Header.view <|
            let
                innerView =
                    Components.Booking.view
                        { title = "Booking"
                        , apartment = model.apartment
                        , booking = model.booking
                        , price = model.price
                        , today = model.today
                        , body = [ ]
                        }
            in
                { title = innerView.title
                , body = fromUnstyled (render viewToast model.tray (config ToastMsg)) :: innerView.body
                }
