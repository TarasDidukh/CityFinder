//
//  CitiesServicing.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

protocol CitiesServicing: AnyObject {
    /// Reads city list and prepares it for using
    /// - Parameter completion: notifies when preloading finished
    func preloadCities(completion: @escaping () -> Void)
    
    /// Search cities whose name prefix matches the query (given prefix)
    ///
    /// For instance, assume the following entries:
    ///
    /// * Alabama, US
    /// * Albuquerque, US
    /// * Anaheim, US
    /// * Arizona, US
    /// * Sydney, AU
    ///
    /// If the given prefix is "A", all cities but Sydney should appear. Contrariwise, if the given prefix is "s", the only result should be "Sydney, AU".
    /// If the given prefix is "Al", "Alabama, US" and "Albuquerque, US" are the only results.
    /// If the prefix given is "Alb" then the only result is "Albuquerque, US"
    /// - Parameter request: parameters with a given prefix, cursor, and completion result
    /// - Returns: task object to control it
    func searchCities(_ request: SearchCitiesRequest) -> Task
}
