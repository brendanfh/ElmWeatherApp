module WeatherCard exposing (..)

import Html as H exposing (Html)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options
import Material.Elevation as Elevation
import Material.Typography as Typography
import Models exposing (..)
import Utils.Converter exposing (..)


type alias Model =
    { elevation : Int
    , data : CurrentWeatherData
    }


type Msg
    = NoOp
    | Elevate Int


init : CurrentWeatherData -> ( Model, Cmd Msg )
init wd =
    ( { elevation = -1
      , data = wd
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Elevate k ->
            ( { model | elevation = k }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Material.Model -> (Material.Msg m -> m) -> (Msg -> m) -> Model -> Html m
view mmdl mmsg wrapper model =
    Options.span []
        [ Card.view
            [ Options.css "width" "400px"
            , Options.css "margin" "30px"
            , if model.elevation == 1 then
                Elevation.e8
              else
                Elevation.e2
            , Elevation.transition 250.0
            , Options.onMouseEnter (wrapper <| Elevate 1)
            , Options.onMouseLeave (wrapper <| Elevate -1)
            ]
            [ Card.title
                [ Options.center
                ]
                [ Card.head [] [ H.text "Current" ]
                , Options.div
                    [ Typography.display2
                    , Color.text Color.primary
                    , Options.css "padding" ".5em"
                    ]
                    [ Options.div []
                        [ Options.span [ Options.css "padding" "0 20px 0 0" ]
                            [ Icon.view
                                (darkSkyToMaterialName model.data.icon)
                                [ Color.text Color.primary, Icon.size24 ]
                            ]
                        , H.text ((toString (ceiling model.data.temperature)) ++ "°")
                        ]
                    ]
                ]
            , Card.actions
                [ Card.border
                ]
                [ Card.subhead
                    [ Options.css "display" "flex"
                    , Options.css "justify-content" "space-between"
                    , Options.css "align-items" "center"
                    , Options.css "padding" ".3rem 2.4rem"
                    , Typography.display3
                    , Typography.contrast 1.0
                    ]
                    [ Options.span [ Options.css "width" "100px" ] [ H.text "Now" ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "center" ]
                        [ Icon.view "cloud" [ Color.text Color.primary, Icon.size24 ] ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "right" ]
                        [ H.text "-4°" ]
                    ]
                , Card.subhead
                    [ Options.css "display" "flex"
                    , Options.css "justify-content" "space-between"
                    , Options.css "align-items" "center"
                    , Options.css "padding" ".3rem 2.4rem"
                    , Typography.display3
                    , Typography.contrast 1.0
                    ]
                    [ Options.span [ Options.css "width" "100px" ] [ H.text "Now" ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "center" ]
                        [ Icon.view "wb_sunny" [ Color.text Color.primary, Icon.size24 ] ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "right" ]
                        [ H.text "-4°" ]
                    ]
                , Card.subhead
                    [ Options.css "display" "flex"
                    , Options.css "justify-content" "space-between"
                    , Options.css "align-items" "center"
                    , Options.css "padding" ".3rem 2.4rem"
                    , Typography.display3
                    , Typography.contrast 1.0
                    ]
                    [ Options.span [ Options.css "width" "100px" ] [ H.text "Now" ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "center" ]
                        [ Icon.view "cloud_queue" [ Color.text Color.primary, Icon.size24 ] ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "right" ]
                        [ H.text "-4°" ]
                    ]
                , Card.subhead
                    [ Options.css "display" "flex"
                    , Options.css "justify-content" "space-between"
                    , Options.css "align-items" "center"
                    , Options.css "padding" ".3rem 2.4rem"
                    , Typography.display3
                    , Typography.contrast 1.0
                    ]
                    [ Options.span [ Options.css "width" "100px" ]
                        [ H.text "Now" ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "center" ]
                        [ Icon.view "brightness_2" [ Color.text Color.primary, Icon.size24 ] ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "right" ]
                        [ H.text "-4°" ]
                    ]
                , Card.subhead
                    [ Options.css "display" "flex"
                    , Options.css "justify-content" "space-between"
                    , Options.css "align-items" "center"
                    , Options.css "padding" ".3rem 2.4rem"
                    , Typography.display3
                    , Typography.contrast 1.0
                    ]
                    [ Options.span [ Options.css "width" "100px" ]
                        [ H.text "Now" ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "center" ]
                        [ Icon.view "ac_unit" [ Color.text Color.primary, Icon.size24 ] ]
                    , Options.span [ Options.css "width" "100px", Options.css "text-align" "right" ]
                        [ H.text "-4°" ]
                    ]
                ]
            ]
        , Button.render mmsg
            [ 1, 2 ]
            mmdl
            [ Button.ripple ]
            [ H.text "Hello World!" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
