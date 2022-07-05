//
//  UILabel+SetTextOrHide.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 04/07/22.
//

import UIKit

extension UILabel {
    func setTextOrHide(_ newText: String?) {
        self.text = newText
        self.isHidden = newText == nil || (newText ?? "").isEmpty
    }
    
    func setHTMLText(_ htmlText: String?) {
        guard let htmlText = htmlText else {
            self.isHidden = true
            return
        }
        
        let data = Data(htmlText.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.attributedText = attributedString
        }
    }
}
