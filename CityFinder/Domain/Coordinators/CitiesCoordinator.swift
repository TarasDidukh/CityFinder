//
//  CitiesCoordinator.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import UIKit

protocol CitiesCoordinating {
    func showMap(for city: City)
}

class CitiesCoordinator: Coordinator {
    // MARK: - Properties
    private let router: UINavigationController
    
    // MARK: - Initializer
    init(router: UINavigationController) {
        self.router = router
    }
    
    // MARK: - Navigation
    func start() {
        guard let citiesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesViewController") as? CitiesViewController else {
            assertionFailure("couldn't resolve CitiesViewController from Main Storyboard")
            return
        }
        
        let citiesServices = CitiesService()
        let presenter = CitiesPresenter(citiesService: citiesServices,
                                        view: citiesViewController,
                                        coordinator: self)
        citiesViewController.presenter = presenter
        
        router.pushViewController(citiesViewController, animated: true)
    }
}

extension CitiesCoordinator: CitiesCoordinating {
    func showMap(for city: City) {
        guard let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {
            assertionFailure("couldn't resolve MapViewController from Main Storyboard")
            return
        }
        
        let presenter = MapPresenter(city: city, view: mapViewController)
        mapViewController.presenter = presenter
        router.pushViewController(mapViewController, animated: true)
    }
}

