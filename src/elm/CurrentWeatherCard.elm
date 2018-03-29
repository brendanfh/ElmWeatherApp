module CurrentWeatherCard exposing (..)

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
    Options.span
        [ Options.css "display" "inline-flex"
        ]
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
                [ Card.head
                    [ Typography.headline
                    , Color.text Color.primary
                    ]
                    [ H.text "Currently" ]
                , Options.div
                    [ Color.text Color.primary
                    , Options.css "padding" ".5em"
                    ]
                    [ Options.div
                        [ Typography.display2
                        , Options.center
                        ]
                        [ Options.span [ Options.css "padding" "0 20px 0 0" ]
                            [ Icon.view
                                (darkSkyToMaterialName model.data.icon)
                                [ Color.text Color.primary, Icon.size24 ]
                            ]
                        , H.text <| (toString (ceiling model.data.temperature)) ++ "°"
                        ]
                    , Options.span
                        [ Typography.body2
                        , Options.center
                        ]
                        [ H.text <| "Feels like " ++ (toString (ceiling model.data.apparentTemperature)) ++ "°"
                        ]
                    ]
                ]
            , Card.text
                []
                [ Options.span
                    [ Options.center
                    , Typography.subhead
                    ]
                    [ H.text model.data.summary
                    ]
                , Options.div
                    [ Options.css "display" "flex"
                    , Options.css "justify-content" "space-between"
                    , Typography.body2
                    ]
                    [ Options.span
                        [ Options.css "width" "150px"
                        , Options.css "text-align" "left"
                        , Options.css "margin" "20px"
                        ]
                        [ H.text <| "Precipitation: " ++ (toString (floor (model.data.precipProb * 100))) ++ "%"
                        , H.br [] []
                        , H.text <| "Humidity: " ++ (toString (floor (model.data.humidity * 100))) ++ "%"
                        , H.br [] []
                        , H.text <| "Pressure: " ++ (toString (floor (model.data.pressure))) ++ " mBar"
                        ]
                    , Options.span
                        [ Options.css "width" "150px"
                        , Options.css "text-align" "right"
                        , Options.css "margin" "20px"
                        ]
                        [ H.text <| "Wind speed: " ++ (toString (floor (model.data.windSpeed * 2.23694))) ++ " mph"
                        , H.br [] []
                        , H.text <| "Visibility: " ++ (toString (model.data.visibility)) ++ " km"
                        , H.br [] []
                        , H.text <| "Cloud cover: " ++ (toString (floor (model.data.cloudCover * 100))) ++ "%"
                        ]
                    ]
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
