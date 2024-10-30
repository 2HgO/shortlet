module Pages.NotFound_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html.Styled exposing (..)
import Page exposing (Page)
import Route exposing (Route)
import Components.Header
import Components.Footer
import Misc.View exposing (toUnstyledView)
import Shared
import View exposing (View)
import Css exposing (center, px)
import Html.Styled.Attributes exposing (css)
import Css exposing (textAlign)
import Css exposing (padding)
import Misc.Http exposing (Data(..))


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view _ =
    toUnstyledView <|
        Components.Header.view <|
            let
                footerView = Components.Footer.view <|
                    { title = "Home"
                    , body = []
                    }
            in
                { title = "Not Found"
                , body = List.append [ div [ css [ textAlign center, padding (px 30) ] ] [ h4 [] [ text "Page not found" ] ] ] footerView.body
                , apartments = Loading
                }
