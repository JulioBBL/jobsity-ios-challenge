//
//  Series.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 02/07/22.
//

import Foundation

struct SearchSeries: Decodable {
    let score: Double
    let show: Series
}

// MARK: - Series
struct Series: Decodable, Hashable {
    let id: Int
    let name: String
    let genres: [String]
    let schedule: Schedule
    let image: Image?
    let summary: String?
    private let _embedded: Embedded?
    
    var episodes: [Episode]? {
        self._embedded?.episodes
    }
    
    static func == (lhs: Series, rhs: Series) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Image
struct Image: Decodable {
    let medium, original: String
}

// MARK: - Schedule
struct Schedule: Decodable {
    let time: String
    let days: [String]
    
    func toText() -> String {
        return "Airs every \(days.joined(separator: ", ").replacingLastOccurrenceOfString(", ", with: " and ")) at \(time)"
    }
}

// MARK: - Embedded
struct Embedded: Decodable {
    let episodes: [Episode]
}

// MARK: - Episode
struct Episode: Decodable {
    let name: String
    let season, number: Int
    let image: Image?
    let summary: String
}
