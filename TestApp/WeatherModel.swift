//
//  WeatherModel.swift
//  TestApp
//
//  Created by Amrit Raj on 27/12/25.
//
import Foundation

struct DailyWeather: Identifiable {
    let id = UUID()
    let day: String
    let icon: String
    let temperature: Int
}

struct Weather {
    let city: String
    let condition: String
    let icon: String
    let temperature: Int
    let forecast: [DailyWeather]
}


