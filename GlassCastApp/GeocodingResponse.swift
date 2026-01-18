//
//  GeocodingResponse.swift
//  TestApp
//
//  Created by Amrit Raj on 04/01/26.
//
nonisolated

struct GeocodingResponse: Decodable {
    let results: [GeocodingResult]?
}

struct GeocodingResult: Decodable {
    let name: String
    let country: String?
    let latitude: Double
    let longitude: Double
}
