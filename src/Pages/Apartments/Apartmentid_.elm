module Pages.Apartments.Apartmentid_ exposing (Model, Msg, page)


import Html.Styled exposing (..)
import View
import Page exposing (Page)
import Components.Header
import Components.Hero
import Components.Apartment
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..), HttpError)
import Api.ApartmentData exposing (Apartment, getApartment)
import Shared
import Route exposing (Route)
import Effect exposing (Effect, sendCmd)

page : Shared.Model -> Route ({apartmentid : String}) -> Page Model Msg
page shared route =
    Page.new
        { init = init shared route.params.apartmentid
        , update = update
        , subscriptions = subscriptions
        , view = view route.params
        }


-- INIT


type alias Model =
    { apartment : Data Apartment
    }


init : Shared.Model -> String -> () -> (Model, Effect Msg)
init shared apartmentid _ =
    ({ apartment = Loading }
    , sendCmd <| getApartment shared apartmentid
        { onResponse = ApartmentApiResponded
        }
    )

-- UPDATE


type Msg
    = ApartmentApiResponded (Result HttpError Apartment)


update : Msg -> Model -> (Model, Effect Msg)
update msg model =
    case msg of
        ApartmentApiResponded (Ok data) ->
            ( { model | apartment = Success data }
            , Effect.none
            )
        ApartmentApiResponded (Err _) ->
            ( model
            , Effect.none
            )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW


view : { apartmentid : String } -> Model -> View.View Msg
view params model =
    toUnstyledView <|
        Components.Header.view <|
            Components.Hero.view <|
                let
                    innerView = 
                        Components.Apartment.view
                            { title = "Home"
                            , apartment = model.apartment
                            , body = []
                            }
                in
                    { title = innerView.title
                    , apartment = Just params.apartmentid
                    , body = innerView.body
                    }
