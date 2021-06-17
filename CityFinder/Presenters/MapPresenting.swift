//
//  MapPresenting.swift
//  CityFinder
//
//  Created by Taras Didukh on 17.06.2021.
//

protocol MapPresenting: AnyObject {
    var name: String { get }
    var coordinate: Coordinate { get }
}
