//
//  CitiesServise.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import Foundation

class CitiesService: CitiesServising {
    private var groupedCities: [Character: [City]] = [:]
    
    func preloadCities() {
        DispatchQueue.global().async { [weak self] in
            guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
                assertionFailure("cities.json file is missed in the project bundle")
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let cities = try decoder.decode([City].self, from: data)
                self?.preprocessCities(cities)
                debugPrint("successfully preloaded cities")
            } catch {
                // TODO: handle parsing error
                print(error)
            }
        }
    }
    
    /// Helper to prepare cities for using
    ///
    /// Should be used in a background queue
    /// - Parameter cities: list of city
    private func preprocessCities(_ cities: [City]) {
        // The idea here is to group cities in the dictionary with an alphabetical letter as a key
        groupedCities = Dictionary(grouping: cities, by: { city -> Character in
            return city.name.first!
        })
        // Ensure cities are sorted alphabetically inside each key
        groupedCities.keys.forEach { letter in
            self.groupedCities[letter]?.sort(by: { $0.displayName < $1.displayName })
        }
    }
}
