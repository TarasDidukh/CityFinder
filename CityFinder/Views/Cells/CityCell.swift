//
//  CityCell.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import UIKit

class CityCell: UITableViewCell {
    static let id = "CityCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    
    var city: City? {
        didSet {
            guard let city = city else { return }
            titleLabel.text = city.displayName
            detailsLabel.text = city.coordinate.formatted
        }
    }
}
