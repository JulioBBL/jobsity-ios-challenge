//
//  String+easyJoining.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 04/07/22.
//

import Foundation

extension String {
    func replacingLastOccurrenceOfString(_ searchString: String, with replacementString: String) -> String {
        if let range = self.range(of: searchString,
                options: [.backwards],
                range: nil,
                locale: nil) {

            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}
