module Utils.TimeGraph exposing (..)

import Date exposing (Date)
import Html exposing (Html)
import Time exposing (Time)
import Visualization.Axis as VAxis
import Visualization.Scale as VScale
import Visualization.Shape as VShape
import Svg exposing (Svg)
import Svg.Attributes as SA


type alias Model d =
    { times : d -> Time
    , heights : d -> Float
    , data : List d
    , xRange : ( Float, Float )
    , yDomain : ( Float, Float )
    , yRange : ( Float, Float )
    , xTicks : Int
    , yTicks : Int
    , lineColor : String
    , areaColor : String
    , size : ( Float, Float )
    , xAxisOffset : ( Float, Float )
    , yAxisOffset : ( Float, Float )
    }


type Msg d
    = NoOp
    | UpdateData (List d)


update : Msg d -> Model d -> ( Model d, Cmd (Msg d) )
update msg model =
    case msg of
        UpdateData data ->
            ( { model | data = data }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


getStartTime : Model d -> Date
getStartTime model =
    model.data
        |> List.map model.times
        |> List.minimum
        |> Maybe.withDefault 0
        |> Date.fromTime


getEndTime : Model d -> Date
getEndTime model =
    model.data
        |> List.map model.times
        |> List.maximum
        |> Maybe.withDefault 0
        |> Date.fromTime


xScale : Model d -> VScale.ContinuousTimeScale
xScale model =
    let
        start =
            getStartTime model

        end =
            getEndTime model
    in
        VScale.time ( start, end ) model.xRange


yScale : Model d -> VScale.ContinuousScale
yScale model =
    VScale.linear model.yDomain model.yRange


prepareData : { m | times : d -> Time, heights : d -> Float } -> d -> ( Date, Float )
prepareData { times, heights } d =
    ( Date.fromTime <| times d, heights d )


preparedPoints : Model d -> List (Maybe ( Float, Float ))
preparedPoints model =
    model.data
        |> List.map
            (prepareData model
                >> (\( x, y ) ->
                        Just
                            ( VScale.convert (xScale model) x
                            , VScale.convert (yScale model) y
                            )
                   )
            )


viewGridLines : Model d -> Svg m
viewGridLines model =
    let
        start =
            getStartTime model

        end =
            getEndTime model

        defaultOps =
            VAxis.defaultOptions
    in
        Svg.g
            []
            [ Svg.g
                [ SA.transform <| "translate" ++ (toString model.xAxisOffset)
                ]
                [ VAxis.axis
                    { defaultOps
                        | orientation = VAxis.Bottom
                        , tickCount = model.xTicks
                    }
                    (xScale model)
                ]
            , Svg.g
                [ SA.transform <| "translate" ++ (toString model.yAxisOffset)
                ]
                [ VAxis.axis
                    { defaultOps
                        | orientation = VAxis.Left
                        , tickCount = model.yTicks
                    }
                    (yScale model)
                ]
            ]


viewLine : Model d -> Svg m
viewLine model =
    let
        path =
            model
                |> preparedPoints
                |> VShape.line VShape.naturalCurve
                |> SA.d
    in
        Svg.path
            [ path
            , SA.strokeWidth "3"
            , SA.stroke model.lineColor
            , SA.fill "none"
            ]
            []


viewArea : Model d -> Svg m
viewArea model =
    let
        createBars model ( x, y ) =
            ( ( x, Tuple.second (VScale.rangeExtent (yScale model)) )
            , ( x, y )
            )

        path =
            model
                |> preparedPoints
                |> List.map (Maybe.map (createBars model))
                |> VShape.area VShape.naturalCurve
                |> SA.d
    in
        Svg.path
            [ path
            , SA.strokeWidth "3"
            , SA.stroke "none"
            , SA.fill model.areaColor
            ]
            []


view : Model d -> Html m
view model =
    Svg.svg
        [ SA.width <| toString <| Tuple.first model.size
        , SA.height <| toString <| Tuple.second model.size
        ]
        [ viewGridLines model
        , viewLine model
        , viewArea model
        ]
