module Dialog exposing (Config, view, map, mapMaybe)

{-| Elm Modal Dialogs.

@docs Config, view, map, mapMaybe

-}

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input


{-| Renders a modal dialog whenever you supply a `Config msg`.

To use this, include this view in your _top-level_ view function,
right at the top of the DOM tree, like so:

    type Msg
      = ...
      | ...
      | CloseDialog


    view : -> Model -> Element Msg
    view model =
        let
            config =
                { closeMessage = Just CloseDialog
                , maskAttributes = []
                , containerAttributes = [ padding 10 ]
                , headerAttributes = []
                , bodyAttributes = []
                , footerAttributes = []
                , header = Just (text "Hello world")
                , body = Nothing
                , footer = Nothing
                }

            dialogConfig =
                if model.showDialog then
                    Just config

                else
                    Nothing
        in
        Element.layout
            [ inFront (Dialog.view dialogConfig)
            ]
            contentView

It's then up to you to replace `model.showDialog` with whatever
logic should cause the dialog to be displayed, and to handle an
`CloseDialog` message with whatever logic should occur when the user
closes the dialog.

See the `examples/` directory for examples of how this works for apps
large and small.

-}
view : Maybe (Config msg) -> Element msg
view maybeConfig =
    case maybeConfig of
        Nothing ->
            none

        Just config ->
            el
                ([ Background.color dialogMask
                 , width fill
                 , height fill
                 ]
                    ++ config.maskAttributes
                )
            <|
                column config.containerAttributes
                    [ wrapHeader config
                    , wrapBody config
                    , wrapFooter config
                    ]


wrapHeader : Config msg -> Element msg
wrapHeader { header, headerAttributes, closeMessage } =
    if header == Nothing && closeMessage == Nothing then
        none

    else
        row
            ([ width fill, padding 2 ] ++ headerAttributes)
            [ el [ alignLeft ] <| Maybe.withDefault none header
            , maybe none closeButton closeMessage
            ]


closeButton : msg -> Element msg
closeButton closeMessage =
    Input.button [ alignRight, padding 1, Font.size 16 ]
        { onPress = Just closeMessage
        , label = text "x"
        }


wrapBody : Config msg -> Element msg
wrapBody { body, bodyAttributes } =
    case body of
        Nothing ->
            none

        Just body_ ->
            el ([ width fill, padding 1 ] ++ bodyAttributes) body_


wrapFooter : Config msg -> Element msg
wrapFooter { footer, footerAttributes } =
    case footer of
        Nothing ->
            none

        Just footer_ ->
            el ([ width fill, padding 1 ] ++ footerAttributes) footer_


dialogMask =
    rgba 0 0 0 0.3


{-| The configuration for the dialog you display. The `header`, `body`
and `footer` are all `Maybe (Element msg)` blocks. Those `(Element msg)` blocks can
be as simple or as complex as any other view function.

Use only the ones you want and set the others to `Nothing`.

The `closeMessage` is an optional `Signal.Message` we will send when the user
clicks the 'X' in the top right. If you don't want that X displayed, use `Nothing`.

-}
type alias Config msg =
    { closeMessage : Maybe msg
    , maskAttributes : List (Attribute msg)
    , containerAttributes : List (Attribute msg)
    , headerAttributes : List (Attribute msg)
    , bodyAttributes : List (Attribute msg)
    , footerAttributes : List (Attribute msg)
    , header : Maybe (Element msg)
    , body : Maybe (Element msg)
    , footer : Maybe (Element msg)
    }


{-| This function is useful when nesting components with the Elm
Architecture. It lets you transform the messages produced by a
subtree.
-}
map : (a -> b) -> Config a -> Config b
map f config =
    { closeMessage = Maybe.map f config.closeMessage
    , maskAttributes = List.map (Element.mapAttribute f) config.maskAttributes
    , containerAttributes = List.map (Element.mapAttribute f) config.containerAttributes
    , headerAttributes = List.map (Element.mapAttribute f) config.headerAttributes
    , bodyAttributes = List.map (Element.mapAttribute f) config.bodyAttributes
    , footerAttributes = List.map (Element.mapAttribute f) config.footerAttributes
    , header = Maybe.map (Element.map f) config.header
    , body = Maybe.map (Element.map f) config.body
    , footer = Maybe.map (Element.map f) config.footer
    }


{-| For convenience, a varient of `map` which assumes you're dealing with a `Maybe (Config a)`, which is often the case.
-}
mapMaybe : (a -> b) -> Maybe (Config a) -> Maybe (Config b)
mapMaybe =
    Maybe.map << map


maybe : b -> (a -> b) -> Maybe a -> b
maybe default f value =
    case value of
        Just value_ ->
            f value_

        Nothing ->
            default
