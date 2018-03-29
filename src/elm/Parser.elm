module Parser exposing (..)

import Models exposing (..)
import Json.Decode as D
import Json.Decode.Pipeline exposing (decode, required, optional)


darkSkyParser : D.Decoder WeatherData
darkSkyParser =
    decode WeatherData
        |> required "currently" currentWeatherDataParser
        |> required "hourly" hourlyWeatherDataParser
        |> required "daily" dailyWeatherDataParser


currentWeatherDataParser : D.Decoder CurrentWeatherData
currentWeatherDataParser =
    decode CurrentWeatherData
        |> required "time" D.float
        |> required "summary" D.string
        |> required "icon" D.string
        |> required "temperature" D.float
        |> required "apparentTemperature" D.float
        |> required "precipProbability" D.float
        |> required "precipIntensity" D.float
        |> required "humidity" D.float
        |> required "pressure" D.float
        |> required "windSpeed" D.float
        |> required "cloudCover" D.float
        |> required "visibility" D.float


hourlyWeatherDataParser : D.Decoder HourlyWeatherData
hourlyWeatherDataParser =
    decode HourlyWeatherData
        |> required "summary" D.string
        |> required "icon" D.string
        |> required "data" (D.list singleHourWeather)


singleHourWeather : D.Decoder SingleHourWeatherData
singleHourWeather =
    decode SingleHourWeatherData
        |> required "time" D.float
        |> required "summary" D.string
        |> required "icon" D.string
        |> required "temperature" D.float
        |> required "apparentTemperature" D.float
        |> required "precipProbability" D.float
        |> required "precipIntensity" D.float
        |> required "humidity" D.float
        |> required "pressure" D.float
        |> required "windSpeed" D.float
        |> required "cloudCover" D.float
        |> required "visibility" D.float


dailyWeatherDataParser : D.Decoder DailyWeatherData
dailyWeatherDataParser =
    decode DailyWeatherData
        |> required "summary" D.string
        |> required "icon" D.string
        |> required "data" (D.list singleDayWeather)


singleDayWeather : D.Decoder SingleDayWeatherData
singleDayWeather =
    decode SingleDayWeatherData
        |> required "time" D.float
        |> required "summary" D.string
        |> required "icon" D.string
        |> required "moonPhase" D.float
        |> required "temperatureHigh" D.float
        |> required "temperatureLow" D.float
        |> required "precipProbability" D.float
        |> required "precipIntensity" D.float
        |> required "humidity" D.float
        |> required "pressure" D.float
        |> required "windSpeed" D.float
        |> required "cloudCover" D.float
