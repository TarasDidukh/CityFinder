//
//  CitiesServicing.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

protocol CitiesServicing: AnyObject {
    /// Reads city list and prepares it for using
    func preloadCities()
}
