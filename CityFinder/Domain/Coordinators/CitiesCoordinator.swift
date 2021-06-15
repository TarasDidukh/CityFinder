//
//  CitiesCoordinator.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import UIKit

struct CitiesCoordinator: Coordinator {
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
        citiesServices.preloadCities()
        let presenter = CitiesPresenter(citiesService: citiesServices, view: citiesViewController)
        citiesViewController.presenter = presenter
        
        router.pushViewController(citiesViewController, animated: true)
    }
    
}
