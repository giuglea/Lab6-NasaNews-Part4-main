//
//  UIView+Extensions.swift
//  NasaNews
//
//  Created by GigiFullSpeed on 08.04.2022.
//

import UIKit


extension UIView {
    @discardableResult
    func setTag(tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    @discardableResult
    func setConstraints(width: CGFloat, height: CGFloat) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        let width = self.widthAnchor.constraint(equalToConstant: width)
        let height =  self.heightAnchor.constraint(equalToConstant: height)
        
        width.priority = .required
        height.priority = .required
        
        NSLayoutConstraint.activate([
            width,
            height
        ])
        
        return self
    }
    
    @discardableResult
    func setBackgroundColor(color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func setTintColor(color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    func rotate() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 5
        self.layer.add(rotation, forKey: "rotateAnimation")
        
    }
    
    func sizeTransform() {
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        animation.fromValue = 1
        animation.toValue = 2
        animation.duration = 0.5
        self.layer.add(animation, forKey: "sclaeAnimation")
    }
    
}
