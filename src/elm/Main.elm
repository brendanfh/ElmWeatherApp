module Main exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
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
import CurrentWeatherCard as CWC
import Graphs.HourlyPrecipGraph as HPG
import Graphs.HourlyTempGraph as HTG
import Http
import Task
import Models exposing (..)
import Parser
import Navigation


type alias Model =
    { mdl : Material.Model
    , card : Maybe CWC.Model
    , hourlyPrecipGraph : HPG.Model
    , hourlyTempGraph : HTG.Model
    , weatherData : Maybe WeatherData
    }


type Msg
    = NoOp
    | WCUpd CWC.Msg
    | HPGUpd HPG.Msg
    | HTGUpd HTG.Msg
    | GetData (Result Http.Error WeatherData)
    | Mdl (Material.Msg Msg)


init : ( Model, Cmd Msg )
init =
    let
        ( hpginit, hpgcmd ) =
            HPG.init

        ( htginit, htgcmd ) =
            HTG.init
    in
        ( { mdl = Material.model
          , card = Nothing
          , weatherData = Nothing
          , hourlyPrecipGraph = hpginit
          , hourlyTempGraph = htginit
          }
        , Cmd.batch
            [ Layout.sub0 Mdl
            , Cmd.map HPGUpd hpgcmd
            , Cmd.map HTGUpd htgcmd
            , Http.request
                { method = "GET"
                , headers = []
                , url = "http://localhost:8080/api/darksky?lat=44.013231&lon=-97.109024"
                , body = Http.emptyBody
                , expect = Http.expectJson Parser.darkSkyParser
                , timeout = Nothing
                , withCredentials = False
                }
                |> Http.send GetData
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetData (Ok data) ->
            let
                ( card, _ ) =
                    CWC.init data.currently
            in
                ( { model
                    | card = Just card
                    , weatherData = Just data
                  }
                , Cmd.batch
                    [ Task.perform (HPG.SetData >> HPGUpd) <| Task.succeed data.hourly
                    , Task.perform (HTG.SetData >> HTGUpd) <| Task.succeed data.hourly
                    ]
                )

        GetData (Err _) ->
            ( model, Cmd.none )

        WCUpd m ->
            let
                res =
                    Maybe.map (CWC.update m) model.card

                nc =
                    Maybe.map Tuple.first res

                cmd =
                    Maybe.withDefault Cmd.none <| Maybe.map Tuple.second res
            in
                ( { model | card = nc }, Cmd.map WCUpd cmd )

        HPGUpd m ->
            let
                ( hg, cmd ) =
                    HPG.update m model.hourlyPrecipGraph
            in
                ( { model | hourlyPrecipGraph = hg }, Cmd.map HPGUpd cmd )

        HTGUpd m ->
            let
                ( hg, cmd ) =
                    HTG.update m model.hourlyTempGraph
            in
                ( { model | hourlyTempGraph = hg }, Cmd.map HTGUpd cmd )

        Mdl m ->
            Material.update Mdl m model

        NoOp ->
            ( model, Cmd.none )


viewHeader : Model -> Html Msg
viewHeader model =
    Layout.row []
        [ Layout.title [] [ H.text "Learning more elm stuff" ]
        ]


viewDrawer : Model -> List (Html Msg)
viewDrawer model =
    [ Layout.title [] [ H.text "This drawer" ]
    , Layout.navigation
        []
        [ Layout.link [ Layout.href "#/potato" ] [ H.text "Goto potato" ]
        , Layout.link [ Layout.href "#/wow" ] [ H.text "Goto wow" ]
        , Layout.link [ Layout.href "#/dog" ] [ H.text "Goto dog" ]
        ]
    ]


viewBody : Model -> Html Msg
viewBody model =
    Options.div
        [ Options.css "padding" "2em"
        , Color.background Color.primaryDark
        ]
        [ Options.div [ Options.center ]
            [ Maybe.withDefault
                (H.text "")
                (Maybe.map (CWC.view model.mdl Mdl WCUpd) model.card)
            ]
        , Options.div
            [ Options.css "display" "flex"
            , Options.css "justify-content" "space-around"
            , Options.css "flex-wrap" "wrap"
            ]
            [ HPG.view model.mdl Mdl HPGUpd model.hourlyPrecipGraph
            , HTG.view model.mdl Mdl HTGUpd model.hourlyTempGraph
            ]
        , Options.div [ Color.text Color.primaryContrast ]
            [ Maybe.withDefault
                (H.text "")
                (Maybe.map (.daily >> .summary >> H.text) model.weatherData)
            ]
        ]


view : Model -> Html Msg
view model =
    H.div
        []
        [ Options.stylesheet """
            .mdl-layout__drawer.is-visible ~ .mdl-layout__content.mdl-layout__content {
                overflow-y: auto;
                overflow-x: hidden;
            }
        """
        , Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ]
            { header = [ viewHeader model ]
            , drawer = viewDrawer model
            , tabs = ( [], [] )
            , main = [ viewBody model ]
            }
        ]
        |> Material.Scheme.topWithScheme Color.BlueGrey Color.Red


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Layout.subs Mdl model.mdl
        ]


main : Program Never Model Msg
main =
    H.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
