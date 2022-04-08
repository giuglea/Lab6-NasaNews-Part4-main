//
//  UIButton+Extensions.swift
//  NasaNews
//
//  Created by GigiFullSpeed on 08.04.2022.
//

import UIKit

extension UIButton {
    @discardableResult
    func setImage(image: UIImage?) -> Self {
        self.setBackgroundImage(image, for: .normal)
        return self
    }
}
