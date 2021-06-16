//
//  SearchCitiesRequest.swift
//  CityFinder
//
//  Created by Taras Didukh on 16.06.2021.
//

import Foundation

struct SearchCitiesRequest {
    let query: String?
    let skip: Int
    let take: Int
    let completion: ([City]) -> Void
}
