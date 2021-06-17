//
//  MapPresenter.swift
//  CityFinder
//
//  Created by Taras Didukh on 17.06.2021.
//

class MapPresenter: MapPresenting {
    private(set) var name: String
    private(set) var coordinate: Coordinate
    
    init(city: City,
         // let view be here for future use
         view: MapViewProtocol) {
        self.name = city.displayName
        self.coordinate = city.coordinate
    }
}
