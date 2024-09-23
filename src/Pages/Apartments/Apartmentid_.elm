module Pages.Apartments.Apartmentid_ exposing (Model, Msg, page)


import Html.Styled exposing (..)
import View as V
import Page exposing (Page)
import Components.Header
import Components.Hero
import Components.Apartment
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..), HttpError)
import Api.ApartmentData exposing (Apartment, getApartment)


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
    { apartment : Data Apartment
    }


init : String -> (Model, Cmd Msg)
init apartmentid =
    ({ apartment = Success { id = "id"
        , isAvailable = True
        , name = "Bella Loft"
        , address = "address"
        , images = ["/img/bella-loft-01.jpg", "/img/bella-loft-03.jpg", "/img/bella-loft-04.jpg", "/img/bella-loft-05.jpg", "/img/bella-loft-07.jpg", "/img/bella-loft-08.jpg", "/img/bella-loft-09.jpg", "/img/bella-loft-10.jpg"]
        , rate = 45.05
        }
    }
    , getApartment apartmentid
        { onResponse = ApartmentApiResponded
        }
    )



-- UPDATE


type Msg
    = ApartmentApiResponded (Result HttpError Apartment)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ApartmentApiResponded (Ok data) ->
            ( { model | apartment = Success data }
            , Cmd.none
            )
        ApartmentApiResponded (Err _) ->
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
            Components.Apartment.view
                { title = "Home"
                , apartment = model.apartment
                , body = [ text("Apartment ID " ++ params.apartmentid)]
                }
