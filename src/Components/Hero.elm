module Components.Hero exposing (..)

import Html.Styled exposing (Html, div, text, a, img, h1, p, span, br)
import Html.Styled.Attributes exposing (class, href, src)
import Misc.View exposing (StyledView)

view :
    { title : String
    , apartment : Maybe String
    , body : List (Html msg) 
    }
    -> StyledView msg
-- view : Html msg
view props =
    { title = props.title
    , body = div [ class "hero" ]
        [ div [ class "container" ]
            [ div [ class "row justify-content-between" ]
                [ div [ class "col-lg-5" ]
                    [ div [ class "intro-excerpt" ]
                        [ h1 [] [ br[][], span [ class "d-block" ] [ text (if List.member props.title ["Home", "Booking", "Contact"] then "Bella Shortlet Apartments" else props.title) ] ]
                        , p [ class "mb-4" ] [ text "Shortlets available for rent" ]
                        , if (props.title /= "Home" ) then p [] [ a [ href <| getButtonHref props.apartment, class "btn btn-secondary me-2" ] [ text "Book Now" ] ] else span [] []
                        ]
                    ]
                , div [ class "col-lg-7" ]
                    [ div [ class "hero-img-wrap" ] [ img [ src "/img/bella-loft-08.jpg", class "img-fluid" ] [] ]
                    ]
                ]
            
            ]
        ] :: props.body
    }
    

getButtonHref : Maybe String -> String
getButtonHref val =
    case val of
        Just apartmentid ->
            "/bookings/" ++ apartmentid
        Nothing ->
            "/bookings"
