import Foundation

struct DailyWeather: Identifiable {
    let id = UUID()
    let day: String
    let icon: String
    let temperature: Int
    let highTemperature: Int
    let lowTemperature: Int
}

struct Weather {
    let city: String
    let condition: String
    let icon: String
    let temperature: Int
    let highTemperature: Int
    let lowTemperature: Int
    let forecast: [DailyWeather]
}


