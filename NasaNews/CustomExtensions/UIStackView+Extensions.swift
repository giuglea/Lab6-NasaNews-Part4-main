//
//  UIStackView+Extensions.swift
//  NasaNews
//
//  Created by GigiFullSpeed on 08.04.2022.
//

import UIKit

extension UIStackView {
    static func vetical(views: UIView...) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        for view in views {
            stackView.addArrangedSubview(view)
        }
        
        return stackView
    }
    
    static func horizontal(views: UIView...) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        for view in views {
            stackView.addArrangedSubview(view)
        }
        
        return stackView
    }
}
