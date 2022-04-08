//
//  SearchCollectionViewCell.swift
//  NasaNews
//
//  Created by Tzy on 01.04.2022.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    static let cellId = "SearchCollectionViewCell"
    private lazy var stackView = UIStackView
        .vetical(views: titleLabel, starStackView, spacingView)
    private let titleLabel = UILabel()
    private lazy var starStackView = UIStackView
        .horizontal(views: firstStarSpacer, starCollection, secondStarSpacer)
    private let firstStarSpacer = UIView()
    private let secondStarSpacer = UIView()
    private let starCollection = StarCollection(starType: .small)
    
    private let spacingView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func setUp(title: String, rating: Int) {
        titleLabel.text = title
        starCollection.setStars(rating)
    }
    
    override var reuseIdentifier: String? {
        return SearchCollectionViewCell.cellId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure UI
private extension SearchCollectionViewCell {
    func configure() {
        setupUI()
        addSubviews()
        addConstrains()
    }
    
    func setupUI() {
        titleLabel.numberOfLines = 2
        stackView.backgroundColor = .cyan.withAlphaComponent(0.15)
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.spacing = 5
    }
    
    func addSubviews() {
        contentView.addSubview(stackView)
    }
    
    func addConstrains() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        firstStarSpacer.translatesAutoresizingMaskIntoConstraints = false
        firstStarSpacer.widthAnchor.constraint(equalTo: secondStarSpacer.widthAnchor).isActive = true
        
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
}
