//
//  SeriesTableViewCell.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 02/07/22.
//

import UIKit
import SDWebImage

class SeriesCell: UITableViewCell {
    private lazy var posterView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 10
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    
    private lazy var seriesTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .systemMint
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        
        return label
    }()
    
    private lazy var seriesGenres: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(posterView)
        posterView.addSubview(loaderView)
        self.addSubview(seriesTitle)
        self.addSubview(seriesGenres)
        
        let constraints: [NSLayoutConstraint] = [
            self.heightAnchor.constraint(equalToConstant: 200),
            
            posterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            posterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            posterView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor, multiplier: 0.711),
            
            loaderView.centerXAnchor.constraint(equalTo: posterView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: posterView.centerYAnchor),
            
            seriesTitle.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 20),
            seriesTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            seriesTitle.topAnchor.constraint(equalTo: posterView.topAnchor, constant: 20),
            
            seriesGenres.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 20),
            seriesGenres.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            seriesGenres.topAnchor.constraint(equalTo: seriesTitle.bottomAnchor, constant: 20),
            seriesGenres.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        self.loaderView.stopAnimating()
        
        self.posterView.image = nil
        self.seriesTitle.text = nil
        self.seriesGenres.text = nil
    }
    
    @MainActor func configureWith(viewModel: Series?) {
        if let viewModel = viewModel {
            self.loaderView.stopAnimating()
            
            self.posterView.sd_imageIndicator = SDWebImageActivityIndicator.large
            self.posterView.sd_setImage(with: URL(string: viewModel.image?.medium ?? ""), placeholderImage: UIImage(systemName: "image"))
            self.seriesTitle.text = viewModel.name
            self.seriesGenres.text = viewModel.genres.joined(separator: ", ")
        } else {
            self.loaderView.startAnimating()
            
            self.posterView.image = nil
            self.seriesTitle.text = "🤔"
            self.seriesGenres.text = "Expectation"
        }
        
        layoutIfNeeded()
    }
}
