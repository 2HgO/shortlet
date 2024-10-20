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
                                , h3 [] [ text "High Speed Internet" ], p [] [ text "We offer high speed fiber optic internet facility which means endless online adventure for that serious work and leisure adventure" ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/security.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "24/7 Security" ], p [] [ text "We offer you peace of mind, we offer you 24/7 security with our inhouse private security so your stay with us is stress free." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/light.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "24/7 Electricity" ], p [] [ text "Electricity is not a thing you have to worry about. We offer you 24/7 electricity supply so you can focus on the one thing that we promise you, that is comfortable and luxury living." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/location.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Serene Location" ], p [] [ text "Serene Location. An exquisite, serene and secure gated environment for complete relaxation of self and or with whole family." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/tv.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Smart TV & Premium Cable" ], p [] [ text "Smart and Cable Tvs. Our Smart and Cable TVs offers you access to a wide range of News, Entertainment, Sports, Movies, Documentaries and much more." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/swim.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Swimming Pool" ], p [] [ text "Swimming Pool. It’s not all work and no fun. For that total body exercise, a plunge in our in-house swimming pool is an adventure you will look forward to." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/kitchen.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Fully Equipped Kitchen" ], p [] [ text "Fully Equipped Kitchen; The kitchen is fully equipped with gas powered Cooker, Microwave Oven, Toaster, Coffee Maker, Microwave Heater, Water Heater Kettle. Cooking Wares, Glass Cups. Cooking Utensils, Cutleries and many more to make your stay more home foody compliant than just a strow pass." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/washer.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Washer and Dryer Units" ], p [] [ text "Washing Machine. For your convenience, washing machine is available to take care of your washing needs." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/gym.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Fully Functional Gym" ], p [] [ text "Fully Functional Gym. Stay away from home does not mean stay away from that fitness workout you need to stay fit. Take a trip to our in-house gym you will be amazed at the array of stay fit and workout equipment at your disposal." ]
                                ]
                            ]
                    , div [ class "col-3 col-md-3 mb-5" ]
                            [ div [ class "feature" ]
                                [ div [ class "icon" ]
                                    [ img [ src "img/elevator.svg", alt "Image", class "imf-fluid" ] [] ]
                                , h3 [] [ text "Functioning Elevator" ], p [] [ text "Functioning Elevator. While you are at liberty to walk the staircase to ease out the tension, you can equally laze about to your apartment with the strategically located elevator with no stress." ]
                                ]
                            ]
                    ]
                ]   
            ] :: props.body
    }
