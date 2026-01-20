import Foundation

struct CitySuggestion: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let country: String?
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case country
        case latitude
        case longitude
    }
}

