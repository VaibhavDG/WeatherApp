
import Foundation
nonisolated

struct WeatherAPIResponse: Decodable {
    let current_weather: CurrentWeather
    let daily: DailyWeatherData
}

struct CurrentWeather: Decodable {
    let temperature: Double
    let weathercode: Int
}

struct DailyWeatherData: Decodable {
    let time: [String]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let weathercode: [Int]
}

