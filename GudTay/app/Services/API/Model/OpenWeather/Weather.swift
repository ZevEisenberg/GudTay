public extension OpenWeatherAPI {

    struct Weather: Decodable {
        public let id: Tagged<Weather, Int>
        public let main: Main
        public let weatherDescription: Description

        enum CodingKeys: String, CodingKey {
            case id
            case main
            case weatherDescription = "description"
        }
    }

}
