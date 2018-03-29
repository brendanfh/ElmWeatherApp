module Graphs.HourlyPrecipGraph exposing (Model, Msg(..), init, update, view, subscriptions)

import Html as H exposing (Html)
import Material
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Options as Options
import Material.Typography as Typography
import Models exposing (SingleHourWeatherData, HourlyWeatherData)
import Utils.TimeGraph as TimeGraph


type alias Model =
    { data : Maybe HourlyWeatherData
    , graph : TimeGraph.Model SingleHourWeatherData
    , elevation : Int
    }


type Msg
    = NoOp
    | SetData HourlyWeatherData
    | Elevate Int


init : ( Model, Cmd Msg )
init =
    ( { data = Nothing
      , elevation = 0
      , graph =
            { times = (.time >> ((*) 1000))
            , heights = (.precipProb >> ((*) 100))
            , data = []
            , xRange = ( 50, 650 )
            , yDomain = ( 100, 0 )
            , yRange = ( 50, 350 )
            , xTicks = 21
            , yTicks = 4
            , lineColor = "blue"
            , areaColor = "rgb(200, 200, 255)"
            , size = ( 700, 400 )
            , xAxisOffset = ( 0, 350 )
            , yAxisOffset = ( 50, 0 )
            }
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetData d ->
            let
                ( ntg, _ ) =
                    TimeGraph.update (TimeGraph.UpdateData d.data) model.graph
            in
                ( { model
                    | data = Just d
                    , graph = ntg
                  }
                , Cmd.none
                )

        Elevate k ->
            ( { model
                | elevation = k
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )



{- VIEW HELPERS -}


view : Material.Model -> (Material.Msg m -> m) -> (Msg -> m) -> Model -> Html m
view mmdl mmsg wrapper model =
    Options.span
        [ Options.css "display" "inline-flex"
        ]
        [ Card.view
            [ Options.css "width" "800px"
            , Options.css "margin" "30px"
            , if model.elevation == 1 then
                Elevation.e8
              else
                Elevation.e2
            , Elevation.transition 250
            , Options.onMouseEnter (wrapper <| Elevate 1)
            , Options.onMouseLeave (wrapper <| Elevate 0)
            ]
            [ Card.title
                []
                [ Card.head
                    [ Typography.headline
                    , Color.text Color.primary
                    ] [ H.text "2-day Precipitation Probability" ]
                ]
            , Card.text
                [ Options.css "width" "100%"
                , Options.css "padding" "0 0 16px 0"
                ]
                [ Options.div
                    [ Options.css "display" "flex"
                    , Options.css "justify-content" "center"
                    ]
                    [ TimeGraph.view model.graph
                    ]
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
