//
//  Coordinate.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
   
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

extension Coordinate {
    var formatted: String {
        return "\(latitude), \(longitude)"
    }
}
