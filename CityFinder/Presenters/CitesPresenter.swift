//
//  CititesPresenter.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

class CitiesPresenter: CitiesPresenting {
    private let citiesService: CitiesServicing
    private unowned let view: CitiesViewProtocol
    
    init(citiesService: CitiesServicing,
         view: CitiesViewProtocol) {
        self.citiesService = citiesService
        self.view = view
    }
}
