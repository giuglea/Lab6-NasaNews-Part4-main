//
//  StarCollection.swift
//  NasaNews
//
//  Created by Tzy on 01.04.2022.
//

import UIKit

protocol StarCollectionDelegate: AnyObject {
    func didRate(rate: Int)
}

enum StarCollectionType {
    case large
    case small
}

final class StarCollection: UIView {
    private var stackView = UIStackView()
    
    private var starButton1 = UIButton()
    private var starButton2 = UIButton()
    private var starButton3 = UIButton()
    private var starButton4 = UIButton()
    private var starButton5 = UIButton()
    
    weak var delegate: StarCollectionDelegate?
    
    private var starType: StarCollectionType = .large
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(starType: StarCollectionType) {
        self.starType = starType
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    @objc
    private func didTapStar(sender: UIButton) {
        var number = 1
        for view in stackView.arrangedSubviews {
            
            if number <= sender.tag,
               let button = view as? UIButton {
                let image = UIImage(systemName: "star.fill")?.withTintColor(.yellow)
                button.setImage(image: image)
            }
            
            if number > sender.tag,
               let button = view as? UIButton {
                let image = UIImage(systemName: "star")?.withTintColor(.yellow)
                button.setImage(image: image)
            }
            number += 1
        }
        delegate?.didRate(rate: sender.tag)
    }
    
    func setStars(_ rating: Int) {
        var number = 1
        
        for view in stackView.arrangedSubviews {
            
            if number <= rating,
               let button = view as? UIButton {
                let image = UIImage(systemName: "star.fill")?.withTintColor(.yellow)
                button.setImage(image: image)
            }
            
            if number > rating,
               let button = view as? UIButton {
                let image = UIImage(systemName: "star")?.withTintColor(.yellow)
                button.setImage(image: image)
            }
            number += 1
        }
    }
    
    private func configure() {
        stackView.axis = .horizontal
        stackView.addArrangedSubview(starButton1)
        stackView.addArrangedSubview(starButton2)
        stackView.addArrangedSubview(starButton3)
        stackView.addArrangedSubview(starButton4)
        stackView.addArrangedSubview(starButton5)
        
        
        for (number, view) in stackView.arrangedSubviews.enumerated() {
            switch starType {
            case .large:
                view.setConstraints(width: 30, height: 30)
                    .setTag(tag: number + 1)
                    .setTintColor(color: .red)
            case .small:
                view.setConstraints(width: 10, height: 10)
                    .setTag(tag: number + 1)
                    .setTintColor(color: .red)
            }

            if let button = view as? UIButton {
                let image = UIImage(systemName: "star")
                button.setImage(image: image)
                button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
            }
        }
        
        switch starType {
        case .large:
            stackView.spacing = 5
        case .small:
            stackView.spacing = 2
        }
       
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    
}
