module Pages.Home_ exposing (Model, Msg, page)

import Html.Styled exposing (..)
import View as V
import Page exposing (Page)
import Components.Header
import Components.Hero
import Components.Listing
import Components.Amenities
import Components.AboutBella
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..), HttpError)
import Api.ApartmentData exposing (Apartment, listApartments)

page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

-- INIT


type alias Model =
    { apartments : Data (List Apartment)
    }

init : ( Model, Cmd Msg )
init =
    ( { apartments = Loading }
    , listApartments
        { onResponse = ApartmentApiResponded
        }
    )


-- UPDATE


type Msg
    = ApartmentApiResponded (Result HttpError (List Apartment))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ApartmentApiResponded (Ok data) ->
            ( { model | apartments = Success data }
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

view : Model -> V.View Msg
view model =
    toUnstyledView <|
    Components.Header.view <|
        Components.Hero.view <|
            let
                innerView =
                    Components.Listing.view <|
                        let
                            amenitiesView =
                                Components.Amenities.view <|
                                    Components.AboutBella.view <|
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
                , apartment = Nothing
                , body = innerView.body
                }
