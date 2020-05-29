public extension OpenWeatherAPI {

    struct Weather: Decodable {
        public let id: Tagged<Weather, Int>
        public let main: Main

        /// Could make this a type. Full list of descriptions here: <https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2>
        public let weatherDescription: String
        public let icon: Icon

        enum CodingKeys: String, CodingKey {
            case id
            case main
            case weatherDescription = "description"
            case icon
        }
    }

}

public extension OpenWeatherAPI.Weather {

    var wantsUmbrella: Bool {
        // Docs: https://openweathermap.org/weather-conditions#How-to-get-icon-URL
        // 2xx: Thunderstorm
        // 3xx: Drizzle
        // 5xx: Rain
        // 6xx: Snow
        // 7xx: Atmosphere
        // 800: Clear
        // 80x: Clouds

        (200...599).contains(id.rawValue)
    }

}
