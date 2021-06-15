//
//  City.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

struct City: Decodable {
    let id: Int
    let name: String
    let country: String
    let coordinate: Coordinate
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coordinate = "coord"
    }
}

extension City {
    var displayName: String {
        return "\(name), \(country)"
    }
}
