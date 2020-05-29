public extension OpenWeatherAPI {

    struct Weather: Decodable {
        public let id: Tagged<Weather, Int>
        public let main: Main
        public let weatherDescription: Description
        public let icon: Icon

        enum CodingKeys: String, CodingKey {
            case id
            case main
            case weatherDescription = "description"
            case icon
        }
    }

}
