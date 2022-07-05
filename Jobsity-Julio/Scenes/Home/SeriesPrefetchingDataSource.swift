//
//  SeriesPrefetchingDataSource.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 02/07/22.
//

import Foundation
import UIKit

protocol SearcherDelegate {
    @MainActor func hasStartedLoading()
    @MainActor func hasFinishedLoading()
}

class PaginationManager {
    static let PAGE_SIZE: Int = 250
    
    var pages: [Page] = []
    var delegate: SearcherDelegate?
    
    var allElements: [Series] {
        pages.sorted().flatMap({ $0.pageElements })
    }
    
    func needsToLoad(page newPageNumber: Int) -> Bool {
        guard let page = self.pages.first(where: { $0.pageNumber == newPageNumber }) else { return true }
        return !page.isLoading && page.pageElements.isEmpty
    }
    
    func pageNumber(forElementIn indexPath: IndexPath) -> Int {
        var expectedElementRow = indexPath.row
        let elementsAlreadyLoaded = self.allElements.count

        if expectedElementRow < elementsAlreadyLoaded {
            // this code isn't expected to be executed many times in the current behaviour, but correct expected implementation is provided nonetheless
            for page in pages {
                expectedElementRow = expectedElementRow - page.pageElements.count
                
                if expectedElementRow < 0 {
                    return page.pageNumber
                }
            }
            
            return .zero
        } else {
            // accounts for quirky API behaviour, since every page wont necessarily have 250 elements
            expectedElementRow = expectedElementRow - elementsAlreadyLoaded
            return Int(expectedElementRow / PaginationManager.PAGE_SIZE) + pages.count
        }
    }
}

class SeriesPrefetchingDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    private var paginationManager = PaginationManager()
    private var isInSearchMode = false
    private var latestSearchTerm: String = ""
    private var elementsForSearch = [Series]()
    
    public var delegate: SearcherDelegate?
    
    enum State {
        case showListing
        case searching
        case loadingSearch
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // since the API doesn't say how many indexed series it has, I'll be using an arbritarly large number, which is 100% not the right way to do it.
        let numberOfRows = isInSearchMode ? elementsForSearch.count : 100000
        
        tableView.backgroundView?.isHidden = !(numberOfRows == 0)
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SeriesCell = tableView.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath) as! SeriesCell

        let model = isInSearchMode ? self.elementsForSearch[indexPath.row] : paginationManager.allElements[safe: indexPath.row]
        cell.configureWith(viewModel: model)

        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let expectedPages = Set(indexPaths.map({ paginationManager.pageNumber(forElementIn: $0) }))
        
        guard expectedPages.map({ self.paginationManager.needsToLoad(page: $0) }).contains(true) else {
            return
        } // make sure we don't have / aren't already loading the requested page
        
        self.paginationManager.pages.append(contentsOf: expectedPages.map({ Page(pageNumber: $0, isLoading: true, pageElements: []) }))
        
        expectedPages.forEach { [weak tableView] pageToLoad in
            RequestHandler.makeRequest(.getSeriesList(page: pageToLoad), expection: [Series].self) { [weak tableView, weak self] result in
                guard let self = self else { return }
                guard let page = self.paginationManager.pages.first(where: { $0.pageNumber == pageToLoad }) else { return }
                
                switch result {
                case let .success(pageElements):
                    page.pageElements = pageElements
                case let .failure(error):
                    //TODO: alert user that an error has occured or implement retry mechanism
                    print("⚠️", error)
                }
                
                DispatchQueue.main.async {
                    if let _visibleRows = tableView?.indexPathsForVisibleRows {
                        let visibleRows = Set(_visibleRows)
                        let intersection = Set(indexPaths).intersection(visibleRows)
                        if intersection.count > 0 {
                            tableView?.reloadRows(at: Array(intersection), with: .fade)
                        }
                    }
                }
                
                page.isLoading = false
            }
        }
    }
    
    func doSearch(for searchTerm: String) {
        DispatchQueue.main.async {
            self.delegate?.hasStartedLoading()
        }
        isInSearchMode = !searchTerm.isEmpty
        latestSearchTerm = searchTerm
        
        guard isInSearchMode else {
            self.delegate?.hasFinishedLoading()
            return
        }
        
        //TODO: need debaouncing, as to not make a request for every single keystroke
        RequestHandler.makeRequest(.searchSeries(term: searchTerm), expection: [SearchSeries].self) { [weak self] result in
            guard let self = self, self.latestSearchTerm == searchTerm else { return }
            
            switch result {
            case let .success(wrapperSeries):
                self.elementsForSearch = wrapperSeries.map({ $0.show })
                
            case let .failure(error):
                //TODO: alert user that an error has occured or implement retry mechanism
                print("⚠️", error)
            }
            
            DispatchQueue.main.async {
                self.delegate?.hasFinishedLoading()
            }
        }
    }
    
    func showID(for indexPath: IndexPath) -> Int {
        if isInSearchMode {
            return self.elementsForSearch[indexPath.row].id
        } else {
            return self.paginationManager.allElements[indexPath.row].id
        }
    }
}
