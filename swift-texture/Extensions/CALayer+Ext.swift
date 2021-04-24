//
//  CALayer+Ext.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 25/04/21.
//

import UIKit

extension CALayer {

    func startShimmering() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.secondarySystemFill.cgColor,
            UIColor.quaternarySystemFill.cgColor,
            UIColor.secondarySystemFill.cgColor
        ]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.name = "shimmer_layer"
        insertSublayer(gradientLayer, at: 0)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1
        animation.fromValue = [-1.0, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation, forKey: "shimmer_animation")
    }
    
    func stopShimmering() {
        DispatchQueue.main.async {
            self.sublayers?.removeAll(where: { $0.name == "shimmer_layer" })
        }
    }
}
