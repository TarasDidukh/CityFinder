//
//  ViewController.swift
//  CityFinder
//
//  Created by Taras Didukh on 15.06.2021.
//

import UIKit

class CitiesViewController: UIViewController {
    // MARK: - IBOutlests
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultsLabel: UILabel!
    
    // MARK: - Properties
    var presenter: CitiesPresenting!
    
    // MARK: - Private properties
    private let footerHeight: CGFloat = 30
    private var emptyFooterView = UIView()
    private lazy var loadNextFooterView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerHeight))
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cities Finder"
        setupSearchBar()
        didPreloadCities()
        tableView.tableFooterView = emptyFooterView
    }
    
    // MARK: - UI setup
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.isUserInteractionEnabled = false
    }
}

// MARK: - CitiesViewProtocol implementation
extension CitiesViewController: CitiesViewProtocol {
    func didPreloadCities() {
        guard presenter.citiesLoaded, isViewLoaded else { return }
        
        self.loadingView.isHidden = true
        self.navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
    }
    
    func didSearchCities() {
        guard isViewLoaded else { return }
        
        self.tableView.reloadData()
        self.tableView.tableFooterView = self.presenter.nextResultsExist ? self.loadNextFooterView : self.emptyFooterView
        self.noResultsLabel.isHidden = !self.presenter.filteredCitites.isEmpty
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filteredCitites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCell = tableView.dequeueReusableCell(withIdentifier: CityCell.id, for: indexPath) as! CityCell
        cityCell.city = presenter.filteredCitites[indexPath.row]
        return cityCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if presenter.filteredCitites.count - indexPath.row == 3 {
            presenter.loadNextResults()
        }
    }
}

// MARK: - UISearchBarDelegate implementation
extension CitiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchQueryChanged(to: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.cancelSearchPressed()
    }
}
