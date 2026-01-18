import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var location: CLLocation?
    @Published var city: String = "Cupertino"

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        self.location = location
        fetchCityName(from: location)

        manager.stopUpdatingLocation()
    }

    private func fetchCityName(from location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard
                error == nil,
                let placemark = placemarks?.first
            else { return }

            DispatchQueue.main.async {
                self?.city =
                    placemark.locality ??
                    placemark.subAdministrativeArea ??
                    placemark.administrativeArea ??
                    placemark.country ??
                    "Your Location"
            }
        }
    }
}

