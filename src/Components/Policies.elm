module Components.Policies exposing (..)


import Html.Styled exposing (Html, div, h2, strong, text, li, ul)
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
                        [ h2 [ class "section-title" ] [ strong [] [text "Booking Policies - Reservation Confirmation and Cancellation"] ]]
                    ]
                , div [ class "row justify-content-center" ]
                    [ div [ class "col-md-8 col-lg-8 pb-4 mx-auto" ] 
                        [ div [ class "testimonial-block text-left" ]
                            [ ul [ class "list-group" ]
                                [ li [ class "list-group-item"] 
                                    [ text """
                                        Once guest raise booking notification by completing the online booking form, guest will be sent conditions for the booking confirmation by email.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        Once the conditions for booking confirmation are meant, booking confirmation notice is sent to guest otherwise notice of booking cancellation is sent to guest.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        The guest can cancel confirmed reservation free of charge with full refund 5 day before arrival. The guest will be charged 50% for cancellation made up to 2 days before arrival and No refund for cancellation made 1 day prior to arrival.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        We accept reservations for stays longer than 30 nights upon request and negotiation.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        Guests will be charged N50,000 refundable caution deposit before check in. The deposit will be refunded to guest in full or less the cost of any assessed damaged to items in the apartment prior to check out. Guests will make additional payment if cost of damaged items is more than deposit paid.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        Minimum admittance age is 18 years
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        Smoking is not allowed.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        Pets are not allowed.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        Parties and events are not allowed.
                                        """
                                    ]
                                , li [ class "list-group-item"]
                                    [ text """
                                        There are set quiet hours.
                                        """
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ] :: props.body
    }

