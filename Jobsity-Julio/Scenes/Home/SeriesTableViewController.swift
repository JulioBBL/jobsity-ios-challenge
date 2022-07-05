//
//  SeriesTableViewController.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 02/07/22.
//

import UIKit

class SeriesTableViewController: UITableViewController, SearcherDelegate {
    private let dataSource = SeriesPrefetchingDataSource()
    
    private lazy var backgroundView: EmptyTableBackgroundView = EmptyTableBackgroundView(textForEmpty: "There are no shows here, odd...")
    
    convenience init() {
        self.init(style: .grouped)
        
        self.title = "Series Finder"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .systemMint
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemMint]
        
        self.tableView.register(SeriesCell.self, forCellReuseIdentifier: "SeriesCell")
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 140
        self.tableView.dataSource = dataSource as UITableViewDataSource
        self.tableView.prefetchDataSource = dataSource as UITableViewDataSourcePrefetching
        self.tableView.delegate = self
        self.tableView.backgroundView = backgroundView
        
        self.view.backgroundColor = .systemBackground
        
        self.dataSource.delegate = self
        self.dataSource.tableView(self.tableView, prefetchRowsAt: (0...10).map({ IndexPath(row: $0, section: .zero) })) //triggers prefetch of the first few rows
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Shows"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showId = self.dataSource.showID(for: indexPath)
        
        self.navigationController?.pushViewController(SeriesDetailViewController(forShowWithId: showId), animated: true)
    }
    
    // MARK: - SearcherDelegate
    @MainActor func hasStartedLoading() {
        self.backgroundView.isLoading = true
    }
    
    @MainActor func hasFinishedLoading() {
        self.backgroundView.isLoading = false
        self.tableView.reloadData()
    }
}


extension SeriesTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchTerm = searchController.searchBar.text
      dataSource.doSearch(for: searchTerm ?? "")
  }
}
