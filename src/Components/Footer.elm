module Components.Footer exposing (..)

import Html.Styled exposing (Html, div, p, text, ul, a, li, span)
import Html.Styled.Attributes exposing (class, href)
import Misc.View exposing (StyledView)
import Misc.Http exposing (Data(..))
import Html.Styled exposing (footer)

view :
    { title : String
    , body : List (Html msg)
    }
    -> StyledView msg
-- view : Html msg
view props =
    { title = props.title
    , body = footer [ class "footer-section" ]
        [ div [ class "container relative" ]
            [ div [class "border-top copyright"]
                [ div [ class "row pt-4" ]
                    [ div [class "col-lg-6"]
                        [ p [class "mb-2 text-center text-lg-start"]
                            [text <| String.fromChar (Char.fromCode 169) ++ " 2024 lekkiphaseoneshortlet All Rights Reserved"]
                        ]
                    , div [class "col-lg-6 text-center text-lg-end"]
                        [ ul [class "list-unstyled d-inline-flex ms-auto custom-social"]
                            [ li [] [ a[href "https://instagram.com/Bella_Apartments_2019"] [span [class "fa fa-brands fa-instagram"] [] ]]
                            , li [] [ a[href "mailto:bookings@lekkiphaseoneshortlets.com?subject=Guest%20Enquiry"] [span [class "fa fa-paper-plane"] [] ]]
                            , li [] [ a[href "tel:+2348034020553"] [span [class "fa fa-phone"] [] ]]
                            -- li [] [ a[href "https://x.com/"] [span [class "fa fa-brands fa-twitter"] [] ]]
                            ]
                        ]
                    ]
                ]
            ]
        ] :: props.body
    }
