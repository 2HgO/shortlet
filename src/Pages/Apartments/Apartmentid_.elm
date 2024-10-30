module Pages.Apartments.Apartmentid_ exposing (Model, Msg, page)


import Html.Styled exposing (..)
import View
import Page exposing (Page)
import Components.Header
import Components.Hero
import Components.Apartment
import Components.Footer
import Misc.View exposing (toUnstyledView)
import Misc.Http exposing (Data(..), HttpError)
import Api.ApartmentData exposing (Apartment, getApartment, listApartments)
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
    , apartments : Data (List Apartment)
    }


init : Shared.Model -> String -> () -> (Model, Effect Msg)
init shared apartmentid _ =
    ({ apartment = Loading, apartments = Loading }
    , sendCmd <| Cmd.batch 
        [ getApartment shared apartmentid
            { onResponse = ApartmentApiResponded
            }
        , listApartments shared
            { onResponse = ApartmentsApiResponded
            }
    ])

-- UPDATE


type Msg
    = ApartmentApiResponded (Result HttpError Apartment)
    | ApartmentsApiResponded (Result HttpError (List Apartment))


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
        ApartmentsApiResponded (Ok data) ->
            ( { model | apartments = Success data }
            , Effect.none)
        ApartmentsApiResponded (Err err) ->
            ( { model | apartment = Failure err }
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
            let
                heroView =
                    Components.Hero.view <|
                        let
                            innerView = 
                                Components.Apartment.view <|
                                    let
                                        footerView = 
                                            Components.Footer.view <|
                                                { title = ""
                                                , body = []
                                                }
                                    in
                                        { title = "Home"
                                        , apartment = model.apartment
                                        , body = footerView.body
                                        }
                        in
                            { title = innerView.title
                            , apartment = model.apartment
                            , body = innerView.body
                            }
                in
                    { title = heroView.title
                    , apartments = model.apartments
                    , body = heroView.body
                    }
