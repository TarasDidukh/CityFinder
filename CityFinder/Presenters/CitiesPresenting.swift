//
//  CitiesPresentering.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

protocol CitiesPresenting: AnyObject {
    /// True - when cities have been processed
    var citiesLoaded: Bool { get }
    /// Checks whether lazy loading next portion available
    var nextResultsExist: Bool { get }
    /// Current cities according to a query input
    var filteredCitites: [City] { get }
    
    /// Should be called every time a query input has changed
    ///
    /// Starts searching for cities according to input
    /// - Parameter newValue: of search input
    func searchQueryChanged(to newValue: String?)
    
    /// Lazy loading of the next portion
    func loadNextResults()
    
    /// Resets search query and loads a default cities list
    func cancelSearchPressed()
}
