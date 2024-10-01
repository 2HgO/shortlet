module Components.Listing exposing (..)

import Html.Styled exposing (Html, div, h2, text, p, a, h3, img)
import Html.Styled.Attributes exposing (class, href, src)
import Misc.View exposing (StyledView)
import Api.ApartmentData exposing (Apartment)
import Misc.Http exposing (Data(..))
import Css exposing (paddingBottom)
import Css exposing (px)
import Css exposing (important)
import Html.Styled.Attributes exposing (css)

view :
    { title : String
    , apartments : Data (List Apartment)
    , body : List (Html msg) 
    }
    -> StyledView msg
view props =
    { title = props.title
    , body =
        div [ class "product-section", css [ important <| paddingBottom (px 10) ] ]
            [ div [ class "container" ]
                [ div [ class "row" ] <|
                    div [ class "col-md-12 col-lg-3 mb-5 mb-lg-0" ]
                        [ h2 [ class "mb-4 section-title" ] [ text "Beautifully furnished apartments" ]
                        , p [ class "mb-4" ] [ ]
                        , p [] [ a [ href "#", class "btn" ] [ text "Explore" ] ]
                        ] :: (viewApartmentList props.apartments)                
                ]
            ] :: props.body
    }

viewApartmentList : Data (List Apartment) -> List (Html msg)
viewApartmentList list =
    case list of
        Loading ->
            [ div [ class "has-text-centered p-6" ] 
                [ text "Loading..." ] ]
        Success apartments ->
            List.map viewApartment apartments
        Failure _ ->
            [ div [ class "has-text-centered p-6" ] 
                [ text "Something went wrong..." ] ]

viewApartment : Apartment -> Html msg
viewApartment apartment =
    div [ class "col-12 col-md-4 col-lg-3 mb-5 mb-md-0" ]
        [ a [ class "product-item", href ("/apartments/" ++ apartment.id) ]
            [ img [ src (Maybe.withDefault "#" (List.head apartment.images)), class "img-fluid product-thumbnail" ] []
            , h3 [ class "product-title" ] [ text apartment.name ]
            ]
        ]
