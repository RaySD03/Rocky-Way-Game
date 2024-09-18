//
//  SettingsOverlay.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/28/24.
//

import SpriteKit

class SettingsOverlay: SKShapeNode {
    
    init(size: CGSize) {
        super.init()
        
        // Transparent background for settings menu
        let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.9), size: size)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 100
        addChild(background)
        
        let rocketTexture = SKTexture(imageNamed: "Rocket")
        let rocket = SKSpriteNode(texture: rocketTexture)
        rocket.setScale(1.4)
        rocket.position = CGPoint(x: size.width / 2, y: size.height / 2 + rocket.size.height / 2)
        rocket.zPosition = 101
        self.addChild(rocket)
        
        let rocketLabel = SKLabelNode(text: "Rocket: 1 of 3")
        rocketLabel.fontName = "Marker felt"
        rocketLabel.fontSize = 30
        rocketLabel.fontColor = .white
        rocketLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 70)
        rocketLabel.zPosition = 101
        self.addChild(rocketLabel)
        
        let returnButton = SKSpriteNode(imageNamed: "Close_Button")
        returnButton.name = "closeButton"
        returnButton.position = CGPoint(x: self.frame.minX + returnButton.size.width + 15, y: size.height - 80)
        returnButton.zPosition = 101
        self.addChild(returnButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
