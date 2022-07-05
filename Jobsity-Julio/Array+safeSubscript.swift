//
//  UIImageView+loadURL.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 02/07/22.
//

import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        guard index >= self.startIndex, index < self.endIndex else { return nil }
        return self[index]
    }
}
