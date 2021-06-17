//
//  CitiesServiceTests.swift
//  CityFinderTests
//
//  Created by Taras Didukh on 17.06.2021.
//

import XCTest

@testable import CityFinder

extension City: Equatable {
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.displayName == rhs.displayName
    }
}

class ProductTests: XCTestCase {
    private var citiesService = CitiesServiceMock.shared
    
    override func setUp() {
        super.setUp()
        citiesService.resetDefaultState()
        let preloadCitiesExpectation = expectation(description: "preloaded cities successfully")
        citiesService.preloadCities {
            preloadCitiesExpectation.fulfill()
        }
        wait(for: [preloadCitiesExpectation], timeout: 20)
    }
    
    func testAllCitiesCount() {
        let expectedCount = 209557
        var actualCount = 0
        
        let expectation = expectation(description: "found all cities")
        citiesService.searchCities(SearchCitiesRequest(query: nil, skip: 0, take: Int.max, completion: { cities in
            actualCount = cities.count
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(expectedCount, actualCount)
    }
    
    func testAlphabeticalOrder() {
        let take = 50
        var cities: [City] = []
        
        let expectation = expectation(description: "found up to \(take) cities")
        
        citiesService.searchCities(SearchCitiesRequest(query: nil, skip: 200, take: take, completion: { result in
            cities = result
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 5)
        
        let expectedCitiesOrder = cities.sorted(by: { left, right in
            left.displayName.localizedCaseInsensitiveCompare(right.displayName) == .orderedAscending
        })
        
        XCTAssertEqual(cities, expectedCitiesOrder)
    }
    
    func testPartialSearch() {
        let take = 50
        let searchQuery = "Alb"
        var cities: [City] = []
        
        let expectation = expectation(description: "found up to \(take) cities for prefix \(searchQuery)")
        
        citiesService.searchCities(SearchCitiesRequest(query: searchQuery, skip: 30, take: take, completion: { result in
            cities = result
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 5)
        let expectedCitites = DataUtils.getPartialTestResult()
        
        XCTAssertEqual(cities, expectedCitites)
    }
    
    func testNoResults() {
        var cities: [City] = []
        let expectation = expectation(description: "found 0 cities")
        
        citiesService.searchCities(SearchCitiesRequest(query: "-/~`-=%^=34", skip: 0, take: 10, completion: { result in
            cities = result
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(cities.isEmpty)
    }
    
    func testExceedLimit() {
        var cities: [City] = []
        let expectation = expectation(description: "found 0 cities")
        
        citiesService.searchCities(SearchCitiesRequest(query: "Alb", skip: 5000, take: 10, completion: { result in
            cities = result
            expectation.fulfill()
        }))
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(cities.isEmpty)
    }
    
    func testEmptyPrefixPerfomance() {
        measure {
            let expectation = expectation(description: "found 0 cities")
            citiesService.searchCities(SearchCitiesRequest(query: nil, skip: 10000, take: 10000, completion: { result in
                expectation.fulfill()
            }))
            wait(for: [expectation], timeout: 5)
        }
    }
    
    func testPartialSearchPerformance() {
        measure {
            let expectation = expectation(description: "found 0 cities")
            citiesService.searchCities(SearchCitiesRequest(query: "Ab", skip: 100, take: 6000, completion: { result in
                expectation.fulfill()
            }))
            wait(for: [expectation], timeout: 5)
        }
    }
}
