module Components.Apartment exposing (..)

import Html.Styled exposing (Html, div, text, p, a, img, span)
import Html.Styled.Attributes exposing (class, href, src, attribute)
import Misc.View exposing (StyledView)
import Api.ApartmentData exposing (Apartment)
import Misc.Http exposing (Data(..))
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (usLocale)

view :
    { title : String
    , apartment : Data Apartment
    , body : List (Html msg) 
    }
    -> StyledView msg
view props =
    { title = getApartmentName props.title props.apartment
    , body =
        div [ class "untree_co-section product-section before-footer-section" ]
            [ div [ class "container" ] <|
                viewApartment props.apartment
            ] :: props.body
    }

getApartmentName : String -> Data Apartment -> String
getApartmentName default apartment =
    case apartment of
    Success data -> data.name
    _ -> default

viewApartmentImages : List String -> List (Html msg)
viewApartmentImages list =
    List.map viewApartmentImage list

viewApartmentImage : String -> Html msg
viewApartmentImage ref =
    div [ class "col-12 col-md-4 col-lg-3 mb-5" ]
        [ a [ class "product-item", href "#" ]
            [ img [src ref, class "img-fluid product-thumbnail"] []
            ]
        ]

viewApartment : Data Apartment -> List (Html msg)
viewApartment data =
    case data of
        Loading ->
            [ div [ class "has-text-centered p-6" ] 
                [ text "Loading..." ] ]
        Success apartment ->
            [
                div [ class "row justify-content-center" ]
                    [ div [ class "col-md-8 col-lg-8 pb-4" ]
                        [ div [ class "row mb-5" ]
                            [ label "/img/rate.svg" ("₦" ++ format usLocale apartment.rate)
                            ]
                        ]
                    ]
            ,    div [ class "row" ] (viewApartmentImages apartment.images)
            ]
        Failure _ ->
            [ div [ class "has-text-centered p-6" ] 
                [ text "Something went wrong..." ] ]

label : String -> String -> Html msg
label svgPath value =
    div [class "col-lg-4"]
        [ div [class "service no-shadow align-items-center link horizontal d-flex active", attribute "data-aos" "fade-left", attribute "data-aos-delay" "0"]
            [ div [class "service-icon color-1 mb-4"]
                [ span [] [ img [src svgPath, class "img-fluid" ] [] ]
                ]
            , div [class "service-contents"][ p [] [ text value ] ]
            ]
        ]

