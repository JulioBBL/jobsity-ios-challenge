//
//  EpisodeView.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 04/07/22.
//

import Foundation
import UIKit

class EpisodeView: UIView {
    private lazy var episodeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 10
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var episodeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .systemMint
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .none)
        
        return label
    }()
    
    private lazy var episodeSummaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        
        return label
    }()
    
    init(episodeInfo: Episode) {
        super.init(frame: .zero)
        setupLayout()
        self.setupInfo(with: episodeInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(episodeImageView)
        self.addSubview(episodeNameLabel)
        self.addSubview(episodeSummaryLabel)
        
        let constraints: [NSLayoutConstraint] = [
            episodeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            episodeImageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            episodeImageView.widthAnchor.constraint(equalTo: episodeImageView.heightAnchor, multiplier: 16/9),
            episodeImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            episodeNameLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 10),
            episodeNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            episodeNameLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            episodeNameLabel.bottomAnchor.constraint(equalTo: episodeImageView.bottomAnchor),
            
            episodeSummaryLabel.topAnchor.constraint(equalTo: episodeImageView.bottomAnchor, constant: 10),
            episodeSummaryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            episodeSummaryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            episodeSummaryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.backgroundColor = .clear
    }
    
    private func setupInfo(with episodeModel: Episode) {
        self.episodeImageView.sd_setImage(
            with: URL(string: episodeModel.image?.medium ?? ""),
            placeholderImage: UIImage(systemName: "image")
        )
        
        self.episodeNameLabel.text = "S\(episodeModel.season)EP\(episodeModel.number). \(episodeModel.name)"
        self.episodeSummaryLabel.setHTMLText(episodeModel.summary)
    }
}
