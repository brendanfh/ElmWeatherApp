module Models exposing (..)


type alias CurrentWeatherData =
    { time : Float
    , summary : String
    , icon : String
    , temperature : Float
    , apparentTemperature : Float
    , precipProb : Float
    , precipIntensity : Float
    , humidity : Float
    , pressure : Float
    , windSpeed : Float
    , cloudCover : Float
    , visibility : Float
    }


type alias HourlyWeatherData =
    { sumamry : String
    , icon : String
    , data : List SingleHourWeatherData
    }


type alias SingleHourWeatherData =
    { time : Float
    , summary : String
    , icon : String
    , temperature : Float
    , apparentTemperature : Float
    , precipProb : Float
    , precipIntensity : Float
    , humidity : Float
    , pressure : Float
    , windSpeed : Float
    , cloudCover : Float
    , visibility : Float
    }


type alias DailyWeatherData =
    { summary : String
    , icon : String
    , data : List SingleDayWeatherData
    }


type alias SingleDayWeatherData =
    { time : Float
    , summary : String
    , icon : String
    , moonPhase : Float
    , temperatureHigh : Float
    , temperatureLow : Float
    , precipProb : Float
    , precipIntensity : Float
    , humidity : Float
    , pressure : Float
    , windSpeed : Float
    , cloudCover : Float
    }


type alias WeatherData =
    { currently : CurrentWeatherData
    , hourly : HourlyWeatherData
    , daily : DailyWeatherData
    }
