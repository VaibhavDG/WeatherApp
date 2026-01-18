//
//  WeatherCodeMapper.swift
//  TestApp
//
//  Created by Amrit Raj on 27/12/25.
//
import Foundation

struct WeatherCodeMapper {

    static func icon(for code: Int) -> String {
        switch code {
        case 0:
            return "sun.max.fill"
        case 1, 2:
            return "cloud.sun.fill"
        case 3:
            return "cloud.fill"
        case 45, 48:
            return "cloud.fog.fill"
        case 51, 53, 55, 61, 63, 65:
            return "cloud.rain.fill"
        case 71, 73, 75:
            return "snow"
        case 95:
            return "bolt.fill"
        default:
            return "cloud"
        }
    }

    static func description(for code: Int) -> String {
        switch code {
        case 0:
            return "Clear"
        case 1, 2:
            return "Partly Cloudy"
        case 3:
            return "Cloudy"
        case 61, 63, 65:
            return "Rain"
        case 71, 73, 75:
            return "Snow"
        case 95:
            return "Thunderstorm"
        default:
            return "Unknown"
        }
    }
}

