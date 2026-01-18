//
//  SettingsViewModel.swift
//  GlassCast
//
//  Created by Amrit Raj on 27/12/25.
//
import Foundation
import SwiftUI
import Combine

enum TemperatureUnit: String, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    
    var symbol: String {
        switch self {
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var temperatureUnit: TemperatureUnit {
        didSet {
            UserDefaults.standard.set(temperatureUnit.rawValue, forKey: "temperatureUnit")
        }
    }
    
    private let temperatureUnitKey = "temperatureUnit"
    
    init() {
        if let savedUnit = UserDefaults.standard.string(forKey: "temperatureUnit"),
           let unit = TemperatureUnit(rawValue: savedUnit) {
            self.temperatureUnit = unit
        } else {
            self.temperatureUnit = .celsius
        }
    }
    
    func toggleTemperatureUnit() {
        temperatureUnit = temperatureUnit == .celsius ? .fahrenheit : .celsius
    }
}
