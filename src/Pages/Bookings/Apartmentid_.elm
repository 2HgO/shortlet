module Pages.Bookings.Apartmentid_ exposing (page, Model, Msg)


import Html.Styled exposing (..)
import View as V
import Page exposing (Page)
import Components.Header
import Components.Hero
import Components.Booking exposing (Msg(..))
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..))
import Api.BookingData exposing (createBooking, Booking)
import Api.ApartmentData exposing (Apartment)
import Time exposing (Month(..))
import Date

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
    {
        booking : Booking
        , apartment : Data Apartment
    }


init : String -> (Model, Cmd Msg)
init apartmentid =
    ({
      apartment = Loading
    , booking = {
        fname = ""
        , lname = ""
        , email = ""
        , id = apartmentid
        , startDate = (Date.fromCalendarDate 1970 Jan 1)
        , endDate = (Date.fromCalendarDate 1970 Jan 1)
    }
    }
    ,Cmd.none)



-- UPDATE
updateLname : String -> Model -> Model
updateLname input ({ booking } as model) =
    { model 
    | booking = { booking | lname = input }
    }
updateFname : String -> Model -> Model
updateFname input ({ booking } as model) =
    { model 
    | booking = { booking | fname = input }
    }
updateEmail : String -> Model -> Model
updateEmail input ({ booking } as model) =
    { model 
    | booking = { booking | email = input }
    }
updateStartdate : String -> Model -> Model
updateStartdate input ({ booking } as model) =
    { model 
    | booking = { booking | startDate = Maybe.withDefault (Date.fromCalendarDate 1970 Jan 1) (Result.toMaybe (Date.fromIsoString input)) }
    }
updateEnddate : String -> Model -> Model
updateEnddate input ({ booking } as model) =
    { model 
    | booking = { booking | endDate = Maybe.withDefault (Date.fromCalendarDate 1970 Jan 1) (Result.toMaybe (Date.fromIsoString input)) }
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Fname input -> (updateFname input model, Cmd.none)
        Lname input -> (updateLname input model, Cmd.none)
        Email input -> (updateEmail input model, Cmd.none)
        StartDate input -> (updateStartdate input model, Cmd.none)
        EndDate input -> (updateEnddate input model, Cmd.none)
        Book ->
            (model
            , createBooking {
                onResponse = BookingApiResponded
                ,  booking = model.booking
            })
        BookingApiResponded (Ok _) ->
            ( model
            , Cmd.none
            )
        BookingApiResponded (Err _) ->
            ( model
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
            Components.Booking.view
                { title = "Home"
                , apartment = model.apartment
                , booking = model.booking
                , body = [ text("User ID " ++ params.apartmentid)]
                }
