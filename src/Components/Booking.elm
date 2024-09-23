module Components.Booking exposing (..)


import Html.Styled exposing (Html, div, text, form, label, input, button)
import Html.Styled.Attributes exposing (class, type_, id, value)
import Html.Styled.Events exposing (onInput, onClick)
import Misc.View exposing (StyledView)
import Api.ApartmentData exposing (Apartment)
import Misc.Http exposing (Data(..), HttpError)
import Api.BookingData exposing (Booking, BookingResp)
import Date exposing (toIsoString)

type Msg
    = Fname String
    | Lname String
    | Email String
    | StartDate String
    | EndDate String
    | Book
    | BookingApiResponded (Result HttpError BookingResp)

view :
    { title : String
    , apartment : Data Apartment
    , booking : Booking
    , body : List (Html Msg) 
    }
    -> StyledView Msg
view props =
    { title = "Booking for " ++ (getApartmentName props.title props.apartment)
    , body =
        div [ class "untree_co-section" ]
            [ div [ class "container" ,  id "booking_form" ]
                [ div [class "block"]
                    [ div [ class "row justify-content-center"]
                        [ div [class "col-md-8 col-lg-8 pb-4"]
                            [ form []
                                [ div [class "row"]
                                    [ div [class "col-6"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "First Name" ]
                                            , input [type_ "text", class "form-control", id "fname", value props.booking.fname, onInput Fname] []
                                            ]
                                        ]
                                    , div [class "col-6"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Last Name" ]
                                            , input [type_ "text", class "form-control", id "lname", value props.booking.lname, onInput Lname] []
                                            ]
                                        ]
                                    ]
                                , div [class "form-group"]
                                    [ label [ class "text-black"]
                                        [ text "Email" ] 
                                    , input [type_ "email", class "form-control", id "email", value props.booking.email, onInput Email] []
                                    ]
                                , div [class "form-group"]
                                    [ label [ class "text-black"]
                                        [ text "Email" ] 
                                    , input [type_ "date", class "form-control", id "email", value <| toIsoString props.booking.startDate, onInput StartDate ] []
                                    ]
                                , div [class "form-group mb-5"]
                                    [ label [ class "text-black"]
                                        [ text "Email" ] 
                                    , input [type_ "date", class "form-control", id "email", value <| toIsoString props.booking.endDate, onInput EndDate] []
                                    ]
                                , button [type_ "button", class "btn btn-primary-hover-outline", onClick Book] [ text "Confirm Booking" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ] :: props.body
    }

getApartmentName : String -> Data Apartment -> String
getApartmentName default apartment =
    case apartment of
    Success data -> data.name
    _ -> default
