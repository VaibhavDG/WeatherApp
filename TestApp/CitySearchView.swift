import SwiftUI

struct CitySearchView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        NavigationStack {
            VStack {

                TextField("Search city", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: searchText) { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            // Prevent stale requests
                            if newValue == searchText {
                                viewModel.searchCities(query: newValue)
                            }
                        }
                    }

                List(viewModel.citySuggestions) { city in
                    Button {
                        viewModel.fetchWeather(
                            latitude: city.latitude,
                            longitude: city.longitude,
                            city: city.name
                        )
                        viewModel.citySuggestions = []
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .font(.headline)
                            if let country = city.country {
                                Text(country)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Search City")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

