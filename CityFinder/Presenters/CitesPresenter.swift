//
//  CititesPresenter.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

class CitiesPresenter: CitiesPresenting {
    var filteredCitites: [City] = []
    private(set) var citiesLoaded = false
    private(set) var searchQuery: String?
    
    private let citiesService: CitiesServicing
    private unowned let view: CitiesViewProtocol
    
    init(citiesService: CitiesServicing,
         view: CitiesViewProtocol) {
        self.citiesService = citiesService
        self.view = view
        
        citiesService.preloadCities { [weak self] in
            self?.citiesLoaded = true
        }
    }
}
