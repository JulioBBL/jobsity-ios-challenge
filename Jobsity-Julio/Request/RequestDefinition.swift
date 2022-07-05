//
//  RequestDefinition.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 02/07/22.
//

import Foundation

enum RequestDefinition {
    case getSeries(id: Int)
    case getSeriesList(page: Int)
    case searchSeries(term: String)
    
    
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.tvmaze.com"

        switch self {
        case .getSeries(let id):
            urlComponents.path = "/shows/\(id)"
            urlComponents.queryItems = [
                URLQueryItem(name: "embed", value: "episodes")
            ]
            
        case .getSeriesList(let page):
            urlComponents.path = "/shows"
            urlComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
        case .searchSeries(let term):
            urlComponents.path = "/search/shows"
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: term)
            ]
        }
        
        return urlComponents.url!
    }
    
    var request: URLRequest {
        URLRequest(url: self.url)
    }
}
