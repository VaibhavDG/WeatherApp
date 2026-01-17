//
//  TemperatureConverter.swift
//  GlassCast
//
//  Created by Amrit Raj on 27/12/25.
//
import Foundation

struct TemperatureConverter {
    static func celsiusToFahrenheit(_ celsius: Int) -> Int {
        return Int((Double(celsius) * 9.0 / 5.0) + 32.0)
    }
    
    static func fahrenheitToCelsius(_ fahrenheit: Int) -> Int {
        return Int((Double(fahrenheit) - 32.0) * 5.0 / 9.0)
    }
    
    static func convert(_ celsius: Int, to unit: TemperatureUnit) -> Int {
        switch unit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return celsiusToFahrenheit(celsius)
        }
    }
}
