module Misc.View exposing (..)

import Html.Styled exposing (Html)
import View as V
import Html.Styled exposing (toUnstyled)

type alias StyledView msg =
    { title : String
    , body : List (Html msg)
    }

toUnstyledView : StyledView msg -> V.View msg
toUnstyledView msg =
    { title = msg.title
    , body = List.map toUnstyled msg.body
    }