import SwiftUI
internal import _LocationEssentials
import UIKit


struct ContentView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var showSearch: Bool = false
    
    private var backgroundGradient: LinearGradient {
        guard let condition = viewModel.weather?.condition.lowercased() else {
            return LinearGradient(colors: [.blue, .cyan],
                                  startPoint: .top,
                                  endPoint: .bottom)
        }

        switch condition {
        case _ where condition.contains("clear"),
             _ where condition.contains("sun"):
            return LinearGradient(colors: [.blue, .yellow],
                                  startPoint: .top,
                                  endPoint: .bottom)

        case _ where condition.contains("cloud"):
            return LinearGradient(colors: [.gray, .blue],
                                  startPoint: .top,
                                  endPoint: .bottom)

        case _ where condition.contains("rain"),
             _ where condition.contains("drizzle"):
            return LinearGradient(colors: [.indigo, .gray],
                                  startPoint: .top,
                                  endPoint: .bottom)

        case _ where condition.contains("storm"),
             _ where condition.contains("thunder"):
            return LinearGradient(colors: [.black, .purple],
                                  startPoint: .top,
                                  endPoint: .bottom)

        case _ where condition.contains("snow"):
            return LinearGradient(colors: [.white, .blue],
                                  startPoint: .top,
                                  endPoint: .bottom)

        default:
            return LinearGradient(colors: [.blue, .cyan],
                                  startPoint: .top,
                                  endPoint: .bottom)
        }
    }

    
    var body: some View {
        
            ZStack {
                
                backgroundGradient
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.6), value: viewModel.weather?.condition)

                
                if let weather = viewModel.weather {
                    
                    ScrollView{
                        
                        VStack(spacing: 20) {
                            HStack {
                                Spacer()
                                Button {
                                    showSearch = true
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                            }

                            Text(weather.city)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                            Image(systemName: weather.icon)
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            
                            Text("\(weather.temperature)°")
                                .font(.system(size: 72, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(weather.condition)
                                .foregroundColor(.white)
                            
                            Spacer(minLength: 250)
                            
                            HStack {
                                ForEach(weather.forecast.prefix(5)) { day in
                                    VStack {
                                        Text(day.day)
                                        Image(systemName: day.icon)
                                        Text("\(day.temperature)°")
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            generator.impactOccurred()
                        viewModel.refreshWeather()
                    }
                    
                } else {
                    ProgressView("Getting your weather...")
                        .foregroundColor(.white)
                }
            }
        
            .onChange(of: locationManager.location) { location in
                guard let location else { return }
                
                viewModel.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    city: locationManager.city
                )
            }
            .sheet(isPresented: $showSearch) {
                CitySearchView(viewModel: viewModel)
            }


        }
    }

#Preview {
    ContentView()
}

