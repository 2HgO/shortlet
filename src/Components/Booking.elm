module Components.Booking exposing (..)


import Html as UnstyledHtml
import Html.Styled as Html exposing (Html, div, text, form, label, input, button)
import Html.Styled.Attributes as Attributes exposing (class, type_, id, value, css)
import Html.Styled.Events exposing (onInput, onClick)
import Misc.View exposing (StyledView)
import Api.ApartmentData exposing (Apartment, Price)
import Misc.Http exposing (Data(..), HttpError)
import Api.BookingData exposing (Booking, BookingResp, toString, DateRange, IDType(..), toRepr)
import Date exposing (toIsoString, Date)
import Html.Styled.Attributes exposing (disabled)
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (usLocale)
import Html.Styled exposing (select)
import Html.Styled exposing (option)
import Toast
import Css exposing (backgroundColor, hex, Style, px, paddingTop, padding, margin, fontSize, int)
import Css exposing (maxWidth)
import Css exposing (position)
import Css exposing (absolute)
import Css exposing (zIndex)


type Msg
    = Book
    | BookingApiResponded (Result HttpError BookingResp)
    | UpdateForm FormField String
    | ApartmentApiResponded (Result HttpError Apartment)
    | ApartmentsApiResponded (Result HttpError (List Apartment))
    | GetToday Date
    | PriceApiResponded (Result HttpError Price)
    | ToastMsg Toast.Msg

type FormField
    = Fname
    | Lname
    | Email
    | StartDate
    | EndDate
    | Phone
    | ID
    | IDNumber
    | IDExp

type alias Notification =
    { message : String
    , type_ : NotificationType
    }

type NotificationType
    = SUCCESS
    | ERROR

view :
    { title : String
    , apartment : Data Apartment
    , price : Data Price
    , today : Date
    , booking : Booking
    , body : List (Html Msg) 
    }
    -> StyledView Msg

view props =
    { title = "Booking for " ++ (getApartmentName props.title props.apartment)
    , body =
        div [ css [ paddingTop <| px 25 ] ]
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
                                            , input [type_ "text", class "form-control", value props.booking.fname, onInput (UpdateForm Fname) ] []
                                            ]
                                        ]
                                    , div [class "col-6"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Last Name" ]
                                            , input [type_ "text", class "form-control", value props.booking.lname, onInput (UpdateForm Lname)] []
                                            ]
                                        ]
                                    ]
                                , div [class "form-group"]
                                    [ label [ class "text-black"]
                                        [ text "Email" ] 
                                    , input [type_ "email", class "form-control", value props.booking.email, onInput (UpdateForm Email)] []
                                    ]
                                , div [class "form-group"]
                                    [ label [ class "text-black"]
                                        [ text "Phone Number" ] 
                                    , input [type_ "text", class "form-control", value props.booking.phone, onInput (UpdateForm Phone)] []
                                    ]
                                , div [class "form-group"]
                                    [ div [ class "row" ]
                                        [ div [ class "col-4" ]
                                            [ div [ class "form-group" ]
                                                [ label [ class "text-black"]
                                                    [ text "Identification" ] 
                                                , select [class "form-control", value <| toRepr props.booking.idtype, onInput (UpdateForm ID) ]
                                                    [ option [ value <| toRepr NIN ] [ text <| toString NIN ]
                                                    , option [ value <| toRepr License ] [ text <| toString License ]
                                                    , option [ value <| toRepr Passport ] [ text <| toString Passport ]
                                                    , option [ value <| toRepr VotersCard ] [ text <| toString VotersCard ]
                                                    ]
                                                ]
                                            ]
                                        , div [ class "col-4" ]
                                            [ div [class "form-group"]
                                                [ label [ class "text-black"]
                                                    [ text "Identification Number" ] 
                                                , input [type_ "text", class "form-control", value props.booking.idnumber, onInput (UpdateForm IDNumber)] [] ]
                                            ]
                                        , div [ class "col-4" ]
                                            [ div [class "form-group"]
                                                [ label [ class "text-black"]
                                                    [ text "Expiration" ] 
                                                , input [type_ "date", class "form-control", value <| toIsoString props.booking.idexp, onInput (UpdateForm IDExp)] [] ]
                                            ]
                                        ]
                                    ]
                                , div [class "row"]
                                    [ div [class "col-9"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Check In Date" ]
                                            , input [type_ "date", class "form-control", value <| toIsoString props.booking.range.check_in, onInput (UpdateForm StartDate), Attributes.min <| toIsoString props.today] []
                                            ]
                                        ]
                                    , div [class "col-3"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Check In Time" ]
                                            , input [disabled True, type_ "time", class "form-control", value "14:00"] []
                                            ]
                                        ]
                                    ]
                                , div [class "row"]
                                    [ div [class "col-9"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Check Out Date" ]
                                            , input [type_ "date", class "form-control", value <| toIsoString props.booking.range.check_out, onInput (UpdateForm EndDate), Attributes.min <| toIsoString props.booking.range.check_in] []
                                            ]
                                        ]
                                    , div [class "col-3"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Check Out Time" ]
                                            , input [disabled True, type_ "time", class "form-control", value "11:00"] []
                                            ]
                                        ]
                                    ]
                                , div [class "row mb-5"]
                                    [ div [class "col-2"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Total Nights" ]
                                            , input [type_ "input", disabled True, class "form-control", value <| String.fromInt <| getNights 1 props.price] []
                                            ]
                                        ]
                                    , div [class "col-4"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Rental Cost" ]
                                            , input [type_ "input", disabled True, class "form-control", value <| "₦" ++ format usLocale (getPrice 0 props.booking.range props.apartment props.price) ] []
                                            ]
                                        ]
                                    , div [class "col-2"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Security Deposit" ]
                                            , input [type_ "input", disabled True, class "form-control", value "₦50,000" ] []
                                            ]
                                        ]
                                    , div [class "col-4"]
                                        [ div [class "form-group"]
                                            [ label [ class "text-black"]
                                                [ text "Total Cost" ]
                                            , input [type_ "input", disabled True, class "form-control", value <| "₦" ++ format usLocale ((getPrice 0 props.booking.range props.apartment props.price) + 50000)] []
                                            ]
                                        ]
                                    ]
                                , div[ class "row justify-content-center" ] [button [type_ "button", class "btn btn-primary-hover-outline col-4", onClick Book] [ text "Confirm Booking" ]]
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

getApartmentRate : Float -> Data Apartment -> Float
getApartmentRate default apartment =
    case apartment of
    Success data -> data.rate
    _ -> default

getPrice : Float -> DateRange -> Data Apartment -> Data Price -> Float
getPrice default range apartment price =
    case price of
    Success data -> data.price
    _ ->
        let
            rate = getApartmentRate default apartment
        in
            toFloat (max 1 <| Date.diff Date.Days range.check_in range.check_out) * rate

getNights : Int -> Data Price -> Int
getNights default price =
    case price of
    Success data -> data.nights
    _ -> default

viewToast : List (UnstyledHtml.Attribute msg) -> Toast.Info Notification -> UnstyledHtml.Html msg
viewToast attributes toast =
    Html.toUnstyled <| div ((css <| toastStyles toast) :: List.map Attributes.fromUnstyled attributes) [ text toast.content.message ]

toastStyles : Toast.Info Notification -> List (Style)
toastStyles toast =
    let
        background : Style
        background =
            case toast.content.type_ of
                ERROR ->
                    backgroundColor <| hex "#f77"

                SUCCESS ->
                    backgroundColor <| hex "#7f7"
    in
    [ background
    , maxWidth <| px 250
    , position absolute
    , zIndex <| int 10
    , fontSize <| px 18
    , padding <| px 10
    , margin <| px 10
    ]

