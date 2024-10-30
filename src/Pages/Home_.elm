module Pages.Home_ exposing (Model, Msg, page)

import Html.Styled exposing (..)
import View as V
import Page exposing (Page)
import Components.Header
import Components.Hero
import Components.Listing
import Components.Amenities
import Components.Footer
import Components.AboutBella
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..), HttpError)
import Api.ApartmentData exposing (Apartment, listApartments)
import Shared
import Route exposing (Route)
import Effect exposing (Effect, sendCmd)

page : Shared.Model -> Route () -> Page Model Msg
page shared _ =
    Page.new
        { init = init shared
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

-- INIT


type alias Model =
    { apartments : Data (List Apartment)
    }

init : Shared.Model -> () -> ( Model, Effect Msg )
init shared _ =
    ( { apartments = Loading }
    , sendCmd <| listApartments shared
        { onResponse = ApartmentApiResponded
        }
    )


-- UPDATE


type Msg
    = ApartmentApiResponded (Result HttpError (List Apartment))


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ApartmentApiResponded (Ok data) ->
            ( { model | apartments = Success data }
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

view : Model -> V.View Msg
view model =
    toUnstyledView <|
    Components.Header.view <|
        let
            heroView = Components.Hero.view <|
                let
                    innerView =
                        Components.Listing.view <|
                            let
                                amenitiesView =
                                    Components.Amenities.view <|
                                        Components.AboutBella.view <|
                                            Components.Footer.view <|
                                                { title = "Home"
                                                , body = []
                                                }
                            in
                                { title = amenitiesView.title
                                , apartments = model.apartments
                                , body = amenitiesView.body
                                }
                in
                    { title = innerView.title
                    , apartment = Loading
                    , body = innerView.body
                    }
            in
                { title = heroView.title
                , apartments = model.apartments
                , body = heroView.body
                }
