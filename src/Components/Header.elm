module Components.Header exposing (..)

import List
import Html.Styled exposing (Html, div, nav, text, ul, a, li, span)
import Html.Styled.Attributes exposing (class, href, attribute, classList)
import Misc.View exposing (StyledView)
import Api.ApartmentData exposing (Apartment)
import Misc.Http exposing (Data(..))

view :
    { title : String
    , body : List (Html msg)
    , apartments : Data (List Apartment)
    }
    -> StyledView msg
view props =
    { title = props.title
    , body =
        nav [ class "custom-navbar navbar navbar navbar-expand-md navbar-dark bg-dark", attribute "arial-label" "BELLA navigation bar" ]
            [ div [ class "container" ]
                [ a [ class "navbar-brand", href "/" ] [ text "LEKKI PHASE ONE SHORTLETS", span [] [ text "." ] ]
                -- , button [ class "navbar-toggle", type_ "button", attribute "data-bs-toggle" "collapse", attribute "data-bs-target" "#navbarsFurni", attribute "aria-controls" "navbarsFurni", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation" ] [ span [ class "navbar-toggler-icon" ] [] ]
                , div [ class "collapse navbar-collapse" ]
                    [ ul [ class "custom-navbar-nav navbar-nav ms-auto mb-2 mb-md-0" ] <|
                        List.append (viewApartmentListNav props.title props.apartments) 
                        [ li [ classList [("nav-item active", props.title == "Home") ]] [ a [ class "nav-link", href "/" ] [ text "Home" ] ]
                        ]
                    ]
                ]
            ] :: props.body
    }

viewApartmentListNav : String -> Data (List Apartment) -> List (Html msg)
viewApartmentListNav title list =
    case list of
        Success apartments ->
            List.map (viewApartmentNav title) apartments
        _ ->
            [ ]

viewApartmentNav : String -> Apartment -> Html msg
viewApartmentNav title apartment =
    let
        name =  (String.replace "Bella " "" apartment.name)
    in
        li [ classList [("nav-item active", String.contains name title) ]] [ a [ class "nav-link", href <| "/apartments/" ++ apartment.id ] [ text name ]]
