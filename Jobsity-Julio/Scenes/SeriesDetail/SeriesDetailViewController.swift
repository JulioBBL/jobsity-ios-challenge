//
//  SeriesDetailViewController.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 03/07/22.
//

import UIKit
import SDWebImage

class SeriesDetailViewController: UIViewController {
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    
    private lazy var showNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .largeTitle)
        view.textColor = .systemMint
        
        return view
    }()
    
    private lazy var showPosterView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.setContentHuggingPriority(.required, for: .vertical)
        
        return view
    }()
    
    private lazy var showPosterContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var airingTimeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .systemGray
        
        return view
    }()
    
    private lazy var genresLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .systemGray
        
        return view
    }()
    
    private lazy var sumaryLabel: UILabel = { // any configuration done here is useless, since the API returns HTML formatted text, so no configuration is provided.
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()
    
    private lazy var episodeBannerLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title1)
        view.textColor = .systemMint
        view.text = "Episodes"
        
        return view
    }()
    
    private lazy var episodeStack: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        
        return view
    }()
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        view.isHidden = true
        
        return view
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var showID: Int
    
    init(forShowWithId showID: Int) {
        self.showID = showID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"

        setupLayout()
        fetchSeries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loaderView.startAnimating()
    }
    
    private func fetchSeries() {
        RequestHandler.makeRequest(.getSeries(id: self.showID), expection: Series.self) { result in
            switch result {
            case let .success(seriesData):
                self.setupInfo(with: seriesData)
                
            case .failure:
                let alert = UIAlertController(title: "Oops ☹️", message: "It appears that an error ocurred while fething this show", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Well, go back then", style: .destructive, handler: { [weak self] _ in self?.navigationController?.popViewController(animated: true) }))
                alert.addAction(UIAlertAction(title: "Let's try one more time", style: .default, handler: { [weak self] _ in self?.fetchSeries() }))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(scroll)
        self.view.addSubview(loaderView)
        scroll.addSubview(spacerView)
        spacerView.addSubview(mainStack)
        mainStack.addArrangedSubview(showPosterContainer)
        showPosterContainer.addSubview(showPosterView)
        mainStack.addArrangedSubview(showNameLabel)
        mainStack.addArrangedSubview(genresLabel)
        mainStack.addArrangedSubview(airingTimeLabel)
        mainStack.addArrangedSubview(sumaryLabel)
        mainStack.addArrangedSubview(episodeStack)
        episodeStack.addArrangedSubview(episodeBannerLabel)
        
        let constrainsts = [
            scroll.topAnchor.constraint(equalTo: self.view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            spacerView.topAnchor.constraint(equalTo: scroll.topAnchor),
            spacerView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            spacerView.widthAnchor.constraint(equalTo: scroll.widthAnchor),
            
            mainStack.topAnchor.constraint(equalTo: spacerView.topAnchor, constant: 20),
            mainStack.bottomAnchor.constraint(equalTo: spacerView.bottomAnchor, constant: -20),
            mainStack.leadingAnchor.constraint(equalTo: spacerView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: spacerView.trailingAnchor, constant: -20),
            
            loaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            showPosterView.topAnchor.constraint(equalTo: showPosterContainer.topAnchor),
            showPosterView.bottomAnchor.constraint(equalTo: showPosterContainer.bottomAnchor),
            showPosterView.centerXAnchor.constraint(equalTo: showPosterContainer.centerXAnchor),
            showPosterView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        DispatchQueue.main.async {
            NSLayoutConstraint.activate(constrainsts)
            
            self.view.backgroundColor = .systemBackground
        }
    }
                   
    private func setupInfo(with seriesModel: Series) {
        DispatchQueue.main.async {
            self.loaderView.stopAnimating()
            self.mainStack.isHidden = false
            
            if let imageURL = seriesModel.image?.medium {
                self.showPosterView.sd_setImage(with: URL(string: imageURL))
            } else {
                self.showPosterView.isHidden = true
            }
            
            self.showNameLabel.setTextOrHide(seriesModel.name)
            self.airingTimeLabel.setTextOrHide(seriesModel.schedule.toText())
            self.genresLabel.setTextOrHide(seriesModel.genres.joined(separator: ", "))
            self.sumaryLabel.setHTMLText(seriesModel.summary)
            
            guard let episodes = seriesModel.episodes else { return }
            let episodesBySeason = Dictionary(grouping: episodes, by: { $0.season })
            let seasonNumbers = episodesBySeason.keys.sorted()
            
            for seasonNumber in seasonNumbers {
                guard let episodes = episodesBySeason[seasonNumber] else { continue }
                let seasonView = SeasonView(forSeason: seasonNumber, episodes: episodes)
                self.episodeStack.addArrangedSubview(seasonView)
                seasonView.layoutSubviews()
            }
        }
    }
}
