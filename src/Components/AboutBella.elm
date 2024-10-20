module Components.AboutBella exposing (..)


import Html.Styled exposing (Html, div, h2, text, blockquote)
import Html.Styled.Attributes exposing (class)
import Misc.View exposing (StyledView)
import Misc.Http exposing (Data(..))

view :
    { title : String
    , body : List (Html msg) 
    }
    -> StyledView msg
view props =
    { title = props.title
    , body =
        div [  ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-lg-7 mx-auto text-center" ]
                        [ h2 [ class "section-title" ] [ text "About Bella Shortlets" ]]
                    ]
                , div [ class "row justify-content-center" ]
                    [ div [ class "col-lg-12 mx-auto" ] 
                        [ div [ class "testimonial-block text-center" ]
                            [ blockquote [ class "mb-5" ]
                                [ text """
                                    Bella Shortlet Apartments is located in a serene and gated location Ikate in Lekki Phase 1 area of Lagos. It’s within a walking distance from Nike Art Gallery and about 8 km from Lekki Conservation Centre.

                                    The units are equipped with air conditioning, a flat-screen TV with streaming services, a coffee machine, a shower and a desk. All units come with a kettle, a private bathroom and free WiFi, while selected rooms are fitted with a terrace and some have city views. At the apartment complex, every unit is equipped with bed linen and towels.

                                    An indoor play area is also available for guests at the apartment.

                                    Ikoyi Golf Course is 11 km from Bella Shortlet Apartments, while National Museum Lagos is 11 km away. The nearest airport is Murtala Muhammed International Airport, 29 km from the accommodation.
                                    """
                                ]
                            ]
                        ]
                    ]
                ]
            ] :: props.body
    }
