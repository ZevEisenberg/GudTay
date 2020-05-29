public extension OpenWeatherAPI {

    struct Weather: Codable {
        public let id: Int
        public let main: Main
        public let weatherDescription: Description

        enum CodingKeys: String, CodingKey {
            case id
            case main
            case weatherDescription = "description"
        }
    }

}
