//
//  Coordinate.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

struct Coordinate: Decodable {
    let longitude: Double
    let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
