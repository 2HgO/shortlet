module Components.Amenities exposing (..)

import Html.Styled exposing (Html, div, h2, text, p, h3, img)
import Html.Styled.Attributes exposing (class, src)
import Misc.View exposing (StyledView)
import Misc.Http exposing (Data(..))
import Html.Styled.Attributes exposing (alt)
import Html.Styled.Attributes exposing (css)
import Css exposing (paddingTop)
import Css exposing (important)
import Css exposing (px)

view :
    { title : String
    , body : List (Html msg) 
    }
    -> StyledView msg
view props =
    { title = props.title
    , body =
        div [ class "why-choose-section", css [ important <| paddingTop (px 10) ] ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-lg-7 mx-auto text-center" ]
                        [ h2 [ class "mb-4 section-title" ] [ text "Apartment Amenities" ]
                        , p [ class "mb-4" ] [ ]
                        ]
                    ]
                , div [ class "row my-5" ]
                    [ div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/wifi.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "High Speed Internet" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/security.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "24/7 Security" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/light.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "24/7 Electricity" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/location.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Serene Location" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/tv.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Smart TV & Premium Cable" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/swim.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Swimming Pool" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/kitchen.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Fully Equipped Kitchen" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/washer.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Washer and Dryer Units" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/gym.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Fully Functional Gym" ], p [] []
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/elevator.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Functioning Elevator" ], p [] []
                                ]
                            ]
                    ]
                ]   
            ] :: props.body
    }
