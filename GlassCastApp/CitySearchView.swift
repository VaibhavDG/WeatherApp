import SwiftUI

struct CitySearchView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        NavigationStack {
            VStack {

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("Search city", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background {
                          RoundedRectangle(cornerRadius: 10, style: .continuous)
                              .fill(.thinMaterial)
                              .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
                      }                .padding(.horizontal)
                .padding(.top, 8)
                .onChange(of: searchText) { oldValue, newValue in
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

