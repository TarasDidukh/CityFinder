//
//  CitiesServise.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import Foundation

class CitiesService: CitiesServicing {
    // MARK: - Properties
    private var groupedCities: [Character: [City]] = [:]
    private var sortedKeys: [Character] = []
    private var lastSearchQuery: String?
    private var lastSearchIndex: Int = 0
    private var lastSeachTask: Task?
    
    // MARK: - Public API
    func preloadCities(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
                assertionFailure("cities.json file is missed in the project bundle")
                return
            }
            do {
                debugPrint("started preload cities")
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let cities = try decoder.decode([City].self, from: data)
                self?.preprocessCities(cities)
                debugPrint("successfully preloaded cities")
                completion()
            } catch {
                debugPrint("error occured: \(error)")
                debugPrint("check cities.json file and its format")
            }
        }
    }
    
    @discardableResult
    func searchCities(_ request: SearchCitiesRequest) -> Task {
        let searchWorkItem = DispatchWorkItem { [weak self] in
            self?.searchCitiesExecute(request)
        }
        lastSeachTask = searchWorkItem
        
        DispatchQueue.global(qos: .background).async(execute: searchWorkItem)
        
        return searchWorkItem
    }
    
    func resetDefaultState() {
        lastSearchQuery = nil
        lastSearchIndex = 0
        lastSeachTask?.cancel()
    }
    
    // MARK: - Private methods
    private func searchCitiesExecute(_ request: SearchCitiesRequest) {
        // prepare parameters
        let query = request.query?.lowercased()
        let skip = request.skip
        let take = request.take
        let completion = request.completion
        
        // first case when query exists
        if let query = query,
           !query.isEmpty {
            // searchFromIndex Improves performance in subsequent queries with the same prefix
            // for example [1]: Ab; [2]: Abc
            let searchFromIndex = query.starts(with: lastSearchQuery ?? "??") == true ? lastSearchIndex : 0
            // O(1) get cities list with the same first letter
            guard let citiesGroup = groupedCities[query.first!],
                  // find the first index where search matches
                  let lastSearchIndex = citiesGroup
                    .suffix(from: searchFromIndex)
                    .firstIndex(where: { $0.displayName.lowercased().starts(with: query) }) else {
                completion([])
                return
            }
            // save results for the next search
            self.lastSearchQuery = query
            self.lastSearchIndex = lastSearchIndex
            // filter cities only for a list subrange
            let result = citiesGroup
                .suffix(from: lastSearchIndex + skip)
                .prefix(take)
                .filter { city in
                    return city.displayName.lowercased().starts(with: query)
                }
            completion(result)
        } else {
            // second case - go through all letter keys
            
            // find the first city letter where needs to start
            // accumulate skip index
            // use optional unwrapping construction
            var skipCounter = 0
            guard let startKey = sortedKeys.firstIndex(where: { key in
                    skipCounter += self.groupedCities[key]?.count ?? 0
                    return skipCounter > skip
                }),
                // save cities result from the list of a start key
                var result = groupedCities[sortedKeys[startKey]]?
                    .suffix(skipCounter - skip)
                    .prefix(take) else {
                completion([])
                return
            }
            
            // loop next keys until `take` parameter satisfies `result` list
            let nextKeys = sortedKeys.suffix(from: startKey + 1)
            for key in nextKeys {
                let nextTake = take - result.count
                if nextTake == 0 {
                    break
                }
                if let nextCities = groupedCities[key]?.prefix(nextTake) {
                    result.append(contentsOf: nextCities)
                }
            }
            
            completion(Array(result))
        }
    }
    
    /// Helper to prepare cities for using
    ///
    /// Long-running operation >>> Should be used in a background queue
    /// - Parameter cities: list of city
    private func preprocessCities(_ cities: [City]) {
        // The idea here is to group cities in the dictionary with an alphabetical letter as a key
        groupedCities = Dictionary(grouping: cities, by: { city -> Character in
            return city.name.lowercased().first!
        })
        
        // Ensure keys in the correct alphabetical order
        sortedKeys = groupedCities.keys.sorted(by: { left, right in
            return String(left).localizedCaseInsensitiveCompare(String(right)) == .orderedAscending
            
        })
        // Move any first non-alphabetical keys to the end
        if let firstAlphabetLetter = sortedKeys.firstIndex(where: { letter in
            return [ComparisonResult.orderedDescending,
                    ComparisonResult.orderedSame].contains(String(letter).localizedCaseInsensitiveCompare("a"))
        }) {
            sortedKeys = Array(sortedKeys.suffix(from: firstAlphabetLetter) + sortedKeys.prefix(firstAlphabetLetter))
        }
        
        // Ensure cities are sorted alphabetically inside each key
        groupedCities.keys.forEach { letter in
            self.groupedCities[letter]?.sort(by: { left, right in
                return left.displayName.localizedCaseInsensitiveCompare(right.displayName) == .orderedAscending
            })
        }
    }
}
