import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    enum WeatherSource {
        case location(latitude: Double, longitude: Double, city: String)
        case city(name: String)
    }
    
    @Published var currentSource: WeatherSource?
    
    @Published var weather: Weather?
    @Published var citySuggestions: [CitySuggestion] = []
    private var searchCancellable: AnyCancellable?
    
    
    func weekday(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return "N/A"
        }
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE" // Mon, Tue, Wed
        return weekdayFormatter.string(from: date)
    }
    
    
    func fetchWeather(
        latitude:Double,
        longitude:Double,
        city:String
    )
    {
        currentSource = .location(latitude: latitude, longitude: longitude, city: city)
        let urlString =
        "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=auto"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
                
                let current = response.current_weather
                
                let forecast = zip(
                    response.daily.time,
                    zip(response.daily.weathercode, zip(response.daily.temperature_2m_max, response.daily.temperature_2m_min))
                ).map { date, values in
                    DailyWeather(
                        day: self.weekday(from: date),
                        icon: WeatherCodeMapper.icon(for: values.0),
                        temperature: Int(values.1.0),
                        highTemperature: Int(values.1.0),
                        lowTemperature: Int(values.1.1)
                    )
                }
                
                
                DispatchQueue.main.async {
                    // Get today's high/low from the first forecast day
                    let todayHigh = forecast.first?.highTemperature ?? Int(current.temperature)
                    let todayLow = forecast.first?.lowTemperature ?? Int(current.temperature)
                    
                    self.weather = Weather(
                        city: city,
                        condition: WeatherCodeMapper.description(for: current.weathercode),
                        icon: WeatherCodeMapper.icon(for: current.weathercode),
                        temperature: Int(current.temperature),
                        highTemperature: todayHigh,
                        lowTemperature: todayLow,
                        forecast: forecast
                    )
                }
                
            } catch {
                print("Failed to decode:", error)
            }
        }.resume()
    }
    
    func fetchWeather(city: String) {
        currentSource = .city(name: city)
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        let geocodingURL =
        "https://geocoding-api.open-meteo.com/v1/search?name=\(cityEncoded)&count=1"
        
        guard let url = URL(string: geocodingURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let result = try? JSONDecoder().decode(GeocodingResponse.self, from: data),
                let location = result.results?.first
            else {
                print("City not found")
                return
            }
            self.fetchWeather(
                latitude: location.latitude,
                longitude: location.longitude,
                city: location.name
            )
        }.resume()
    }
    func searchCities(query: String) {
        guard query.count >= 2 else {
            citySuggestions = []
            return
        }
        
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString =
        "https://geocoding-api.open-meteo.com/v1/search?name=\(encoded)&count=5"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let response = try? JSONDecoder().decode(GeocodingResponse.self, from: data)
            else { return }
            
            DispatchQueue.main.async {
                self.citySuggestions = response.results?.map {
                    CitySuggestion(
                        name: $0.name,
                        country: $0.country ?? "",
                        latitude: $0.latitude,
                        longitude: $0.longitude
                    )
                } ?? []
            }
        }.resume()
    }
    func refreshWeather() {
        guard let source = currentSource else { return }
        
        switch source {
        case .location(let lat, let lon, let city):
            fetchWeather(latitude: lat, longitude: lon, city: city)
            
        case .city(let name):
            fetchWeather(city: name)
        }
    }
    
}

    





