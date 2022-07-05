//
//  BackgroundView.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 03/07/22.
//

import UIKit

class EmptyTableBackgroundView: UIView {
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .systemMint
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    
    public var isLoading: Bool {
        didSet {
            if isLoading {
                self.loaderView.startAnimating()
            } else {
                self.loaderView.stopAnimating()
            }
            
            self.emptyLabel.isHidden = isLoading
        }
    }
    
    init(textForEmpty: String, isLoading: Bool = false) {
        self.isLoading = isLoading
        super.init(frame: .zero)
        self.emptyLabel.text = textForEmpty
        
        self.addSubview(emptyLabel)
        self.addSubview(loaderView)
        
        let constraints = [
            emptyLabel.topAnchor.constraint(equalTo: self.topAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
