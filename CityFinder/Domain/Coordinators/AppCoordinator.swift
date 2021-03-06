//
//  AppCoordinator.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import UIKit

class AppCoordinator: Coordinator {
    // MARK: - Properties
    let window: UIWindow
    let router: UINavigationController
    let citiesCoordinator: Coordinator
    
    // MARK: - Initializer
    init(window: UIWindow) {
        self.window = window
        router = UINavigationController()
        citiesCoordinator = CitiesCoordinator(router: router)
    }
    
    // MARK: - Navigation
    func start() {
        window.rootViewController = router
        citiesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
