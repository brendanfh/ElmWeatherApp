module Utils.Converter exposing (..)

darkSkyToMaterialName : String -> String
darkSkyToMaterialName s =
    case s of
        "snow" -> "ac_unit"
        "cloudy" -> "cloud"
        "fog" -> "texture"
        "partly-cloudy-day" -> "cloud"
        "partly-cloudy-night" -> "cloud"
        "clear-day" -> "wb_sunny"
        "clear-night" -> "brightness_2"
        "rain" -> "opacity"
        _ -> s