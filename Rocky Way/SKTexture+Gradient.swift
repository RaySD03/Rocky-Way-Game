//
//  SKTexture+Gradient.swift
//  RockyPath
//
//  Created by Raymond Babayan on 7/23/24.
//

import SpriteKit

extension SKTexture {
    convenience init(gradientColors: [SKColor], size: CGSize) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(image: image)
    }
}
