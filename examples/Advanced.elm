module Basic exposing (main)

{-| -}

import Browser
import Dialog exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


type Msg
    = OpenDialog
    | CloseDialog


type alias Model =
    { showDialog : Bool }


white : Color
white =
    rgb 1 1 1


black : Color
black =
    rgb 0 0 0


gray : Color
gray =
    rgb 0.5 0.5 0.5


red : Color
red =
    rgb 1 0 0


config : Config Msg
config =
    { closeMessage = Just CloseDialog
    , maskAttributes = []
    , containerAttributes =
        [ Background.color white
        , Border.rounded 5
        , centerX
        , centerY
        , padding 10
        , spacing 20
        , width (px 400)
        ]
    , headerAttributes = [ Font.size 24, Font.color red, padding 5 ]
    , bodyAttributes = [ Background.color gray, padding 20 ]
    , footerAttributes = []
    , header = Just (text "Advanced Dialog")
    , body = Just body
    , footer = Just footerButtons
    }


body : Element Msg
body =
    column [ width fill ] [ el [ centerX ] (text "Advanced Dialog body") ]


footerButtons : Element Msg
footerButtons =
    row [ width fill, padding 2, spacing 5 ]
        [ Input.button
            [ Background.color white
            , Font.color black
            , Font.bold
            , Border.rounded 2
            , Border.width 1
            , padding 5
            , alignRight
            , mouseOver
                [ Background.color black
                , Font.color white
                ]
            ]
            { onPress = Just CloseDialog
            , label = text "Ok"
            }
        ]


view : Model -> Html Msg
view model =
    let
        dialogConfig =
            if model.showDialog then
                Just config

            else
                Nothing
    in
    Element.layout
        [ inFront (Dialog.view dialogConfig)
        ]
    <|
        column [ centerX, alignTop, spacing 10, padding 20 ] <|
            [ text "This is the page"
            , Input.button
                [ Background.color white
                , Font.color black
                , Border.rounded 2
                , Border.width 1
                , padding 2
                , mouseOver
                    [ Background.color black
                    , Font.color white
                    ]
                ]
                { onPress = Just OpenDialog
                , label = text "Open Dialog"
                }
            ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        OpenDialog ->
            { model | showDialog = True }

        CloseDialog ->
            { model | showDialog = False }


init : Model
init =
    { showDialog = False }


main =
    Browser.sandbox
        { view = view
        , update = update
        , init = init
        }
