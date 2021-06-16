//
//  ViewController.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import UIKit

class CitiesViewController: UITableViewController {
    var presenter: CitiesPresenting!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cities Finder"
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension CitiesViewController: CitiesViewProtocol {
    
}

extension CitiesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "test"
        cell.detailTextLabel?.text = "detail"
        return cell
    }
}

