//
//  CititesServiceMock.swift
//  CityFinderTests
//
//  Created by Taras Didukh on 17.06.2021.
//

import Foundation

@testable import CityFinder

class CititesServiceMock: CitiesService {
    static let shared = CititesServiceMock()
    private override init() { super.init() }
    private var completions: [() -> Void] = []
    
    private var once = true
    private var isPreloaded = false
    
    /// The function will be running only once. Next calls wait until the first has finished
    override func preloadCities(completion: @escaping () -> Void) {
        guard !isPreloaded else {
            completion()
            return
        }
        
        completions.append(completion)
        guard once else {
            return
        }
        once = false
        super.preloadCities(completion: { [weak self] in
            guard let self = self else { return }
            self.isPreloaded = true
            self.completions.forEach { completion in completion() }
            self.completions.removeAll()
        })
    }
}
