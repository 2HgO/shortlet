module Components.Header exposing (..)

import Html.Styled exposing (Html, div, nav, text, ul, a, li, span)
import Html.Styled.Attributes exposing (class, href, id, attribute, classList)
import Misc.View exposing (StyledView)

view :
    { title : String
    , body : List (Html msg) 
    }
    -> StyledView msg
view props =
    { title = props.title
    , body =
        nav [ class "custom-navbar navbar navbar navbar-expand-md navbar-dark bg-dark", attribute "arial-label" "ODOOE navigation bar" ]
            [ div [ class "container" ]
                [ a [ class "navbar-brand", href "/" ] [ text "ODOOE", span [] [ text "." ] ]
                -- , button [ class "navbar-toggle", type_ "button", attribute "data-bs-toggle" "collapse", attribute "data-bs-target" "#navbarsFurni", attribute "aria-controls" "navbarsFurni", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation" ] [ span [ class "navbar-toggler-icon" ] [] ]
                , div [ class "collapse navbar-collapse", id "navbarsFurni" ]
                    [ ul [ class "custom-navbar-nav navbar-nav ms-auto mb-2 mb-md-0" ]
                        [ li [ classList [("nav-item active", props.title == "Home") ]] [ a [ class "nav-link", href "/" ] [ text "Home" ] ]
                        , li [ classList [("nav-item active", props.title == "Booking") ]] [ a [ class "nav-link", href "/booking" ] [ text "Booking" ] ]
                        , li [ classList [("nav-item active", props.title == "Contact")] ] [ a [ class "nav-link", href "/contact" ] [ text "Contact" ] ]
                        ]
                    ]
                ]
            ] :: props.body
    }
