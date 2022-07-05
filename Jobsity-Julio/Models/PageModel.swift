//
//  PageModel.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 03/07/22.
//

import Foundation

class Page: Comparable, Equatable {
    let pageNumber: Int
    var isLoading: Bool = true
    var pageElements: [Series]
    
    init(pageNumber: Int, isLoading: Bool, pageElements: [Series] = []) {
        self.pageNumber = pageNumber
        self.isLoading = isLoading
        self.pageElements = pageElements
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        return lhs.pageNumber < rhs.pageNumber
    }
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.pageNumber == rhs.pageNumber
    }
}
