module Basic exposing (main)

{-| -}

import Dialog exposing (Config, view)
import Element exposing (..)
import Element.Background as Background


config =
    { closeMessage = Nothing
    , maskAttributes = []
    , headerAttributes = []
    , bodyAttributes = []
    , footerAttributes = []
    , containerAttributes =
        [ Background.color (rgb 1 1 1)
        , centerX
        , centerY
        ]
    , header = Just (text "Basic Dialog")
    , body = Nothing
    , footer = Nothing
    }


main =
    Element.layout [] <|
        Dialog.view (Just config)
