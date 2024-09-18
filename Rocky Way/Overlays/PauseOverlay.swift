//
//  PauseOverlay.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/24/24.
//

import SpriteKit

class PauseOverlay: SKNode {
    init(size: CGSize) {
        super.init()
        
        // Transparent background for pause menu
        let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.85), size: size)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 100
        addChild(background)
        
        // Game Pause label
        let pausedLabel = SKLabelNode(text: "Game Paused")
        pausedLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        pausedLabel.fontName = "Chalkduster"
        pausedLabel.fontSize = 34
        pausedLabel.fontColor = .white
        pausedLabel.zPosition = 101
        addChild(pausedLabel)
        
        // Resume button
        let resumeLabel = SKLabelNode(text: "Resume")
        resumeLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        resumeLabel.name = "resumeLabel"
        resumeLabel.fontName = "Arial"
        resumeLabel.zPosition = 101
        addChild(resumeLabel)
        
        // Quit button
        let quitLabel = SKLabelNode(text: "Quit")
        quitLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        quitLabel.name = "quitLabel"
        quitLabel.fontName = "Arial"
        quitLabel.zPosition = 101
        addChild(quitLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
