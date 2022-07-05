//
//  SeasonView.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 04/07/22.
//

import Foundation
import UIKit

class SeasonView: UIView {
    private lazy var SeasonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .systemMint
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        
        return label
    }()
    
    private lazy var episodeStack: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        
        return view
    }()
    
    init(forSeason seasonNumber: Int, episodes: [Episode]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
        setupInfo(for: seasonNumber, with: episodes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(episodeStack)
        episodeStack.addArrangedSubview(SeasonNameLabel)
        
        let constraints: [NSLayoutConstraint] = [
            episodeStack.topAnchor.constraint(equalTo: self.topAnchor),
            episodeStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            episodeStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            episodeStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupInfo(for seasonNumber: Int, with episodes: [Episode]) {
        self.SeasonNameLabel.text = "Season \(seasonNumber)"
        
        for episode in episodes {
            self.episodeStack.addArrangedSubview(EpisodeView(episodeInfo: episode))
        }
    }
}
