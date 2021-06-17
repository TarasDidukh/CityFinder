//
//  DataUtils.swift
//  CityFinderTests
//
//  Created by Taras Didukh on 17.06.2021.
//

import Foundation

@testable import CityFinder

enum DataUtils {
    static func getPartialTestResult() -> [City] {
        return [("Albaladejo del Cuende", "ES"),("Albaladejo del Cuende", "ES"),("Albaladejo", "ES"),("Albaladejo", "ES"),("Albalat de la Ribera", "ES"),("Albalat de la Ribera", "ES"),("Albalat dels Sorells", "ES"),("Albalat dels Sorells", "ES"),("Albalat dels Tarongers", "ES"),("Albalat dels Tarongers", "ES"),("Albalate de Cinca", "ES"),("Albalate de Cinca", "ES"),("Albalate de las Nogueras", "ES"),("Albalate de las Nogueras", "ES"),("Albalate de Zorita", "ES"),("Albalate de Zorita", "ES"),("Albalate del Arzobispo", "ES"),("Albalate del Arzobispo", "ES"),("Albalatillo", "ES"),("Albalatillo", "ES"),("Alban", "CO"),("Albanchez", "ES"),("Albánchez", "ES"),("Albanel", "CA"),("Albanella", "IT"),("Albania", "CO"),("Albania", "CO"),("Albano di Lucania", "IT"),("Albano Laziale", "IT"),("Albano Laziale", "IT"),("Albano SantAlessandro", "IT"),("Albano Vercellese", "IT"),("Albany County", "US"),("Albany County", "US"),("Albany Creek", "AU"),("Albany", "AU"),("Albany", "AU"),("Albany", "CA"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US"),("Albany", "US")].map { City(id: 0, name: $0.0, country: $0.1, coordinate: Coordinate(latitude: 0, longitude: 0)) }
    }
}
