module Components.Hero exposing (..)

import Html.Styled exposing (Html, div, text, a, img, h1, p, span, br, strong)
import Html.Styled.Attributes exposing (class, href, src)
import Misc.View exposing (StyledView)
import Misc.Http exposing (Data(..))
import Api.ApartmentData exposing (Apartment)

view :
    { title : String
    , apartment : Data Apartment
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
                        , p [ class "mb-4" ] [ strong [] [text "Shortlets available for rent...Experience the art of comfortable and luxury living away from home"] ]
                        , if (props.title /= "Home" && (String.contains "Booking for" props.title /= True)) then p [] [ a [ href ("/bookings" ++ (getApartmentName props.apartment)), class "btn btn-secondary me-2" ] [ text "Book Now" ] ] else span [] []
                        ]
                    ]
                , div [ class "col-lg-7" ]
                    [ div [ class "hero-img-wrap" ] [ img [ src <| viewApartmentHeroImage "/img/bella-loft-hero.jpg" props.apartment, class "img-fluid" ] [] ]
                    ]
                ]
            
            ]
        ] :: props.body
    }

getApartmentName : Data Apartment -> String
getApartmentName apartment =
    case apartment of
    Success data -> "/" ++ data.id
    _ -> ""

viewApartmentHeroImage : String -> Data Apartment -> String
viewApartmentHeroImage default apartment  =
    case apartment of
    Success data -> Maybe.withDefault default (List.head data.images)
    _ -> default
