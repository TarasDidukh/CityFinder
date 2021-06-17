//
//  CititesPresenter.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import Foundation

class CitiesPresenter: CitiesPresenting {
    // MARK: - Properties
    private(set) var filteredCitites: [City] = []
    private(set) var searchQuery: String?
    
    private(set) var nextResultsExist = false
    private(set) var citiesLoaded = false {
        didSet {
            guard citiesLoaded else { return }
            DispatchQueue.main.async { self.view.didPreloadCities() }
        }
    }
    
    // MARK: - Private properties
    private var isLoading = false

    private var lastSearchTask: Task? {
        willSet {
            lastSearchTask?.cancel()
        }
    }
    private let takeCount = 30
    private let citiesService: CitiesServicing
    private unowned let view: CitiesViewProtocol
    private let coordinator: CitiesCoordinating
    
    // MARK: - Init
    init(citiesService: CitiesServicing,
         view: CitiesViewProtocol,
         coordinator: CitiesCoordinating) {
        self.citiesService = citiesService
        self.view = view
        self.coordinator = coordinator
        
        citiesService.preloadCities { [weak self] in
            self?.citiesLoaded = true
            self?.performSearch()
        }
    }
    
    // MARK: - Private methods
    private func performSearch(isNext: Bool = false) {
        let skipCount = isNext ? filteredCitites.count : 0
        let request = SearchCitiesRequest(query: searchQuery, skip: skipCount, take: takeCount) { [weak self] cities in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.nextResultsExist = !cities.isEmpty && cities.count.isMultiple(of: self.takeCount)
                if isNext {
                    self.filteredCitites.append(contentsOf: cities)
                } else {
                    self.filteredCitites = cities
                }
                self.view.didSearchCities()
            }
        }
        isLoading = true
        lastSearchTask = citiesService.searchCities(request)
    }
}

// MARK: - Public API
extension CitiesPresenter {
    func searchQueryChanged(to newValue: String?) {
        self.searchQuery = newValue
        performSearch()
    }
    
    func loadNextResults() {
        guard !isLoading, nextResultsExist else { return }
        performSearch(isNext: true)
    }
    
    func cancelSearchPressed() {
        searchQueryChanged(to: nil)
    }
    
    func citySelected(at index: Int) {
        coordinator.showMap(for: filteredCitites[index])
    }
}
