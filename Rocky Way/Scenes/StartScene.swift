//
//  StartScene.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/24/24.
//

import SpriteKit

class StartScene: SKScene {
    var settingsOverlay: SettingsOverlay?
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFill
        
        // Set background gradient color
        let gradientTexture = SKTexture(gradientColors: [.black, UIColor(red: 45/255, green: 63/255, blue: 70/255, alpha: 1.0)], size: frame.size)
        let background = SKSpriteNode(texture: gradientTexture)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        self.addChild(background)
        
        // Wait for safeAreaInsets
        run(SKAction.wait(forDuration: 0.1)) {
            let startButton = SKLabelNode(text: "Tap to Start")
            startButton.fontSize = 31
            startButton.fontColor = .white
            startButton.fontName = "Marker felt"
            startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            startButton.name = "startButton"
            self.addChild(startButton)
            
            let fadeOut = SKAction.fadeOut(withDuration: 1.5)
            let fadeIn = SKAction.fadeIn(withDuration: 1.5)
            let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
            let repeatFade = SKAction.repeatForever(fadeSequence)
            startButton.run(repeatFade)
            
            let titleImage = SKSpriteNode(imageNamed: "Game_Title_Image")
            titleImage.position = CGPoint(x: self.size.width / 2, y: self.size.height * 3 / 4)
            titleImage.name = "titleImage"
            titleImage.alpha = 0.0
            titleImage.setScale(1.2)
            self.addChild(titleImage)
            
            let settingsButton = SKSpriteNode(imageNamed: "Settings_icon")
            settingsButton.setScale(0.8)
            settingsButton.name = "settingsButton"
            settingsButton.position = CGPoint(x: self.frame.minX + settingsButton.size.width / 2 + 15, y: self.frame.minY + settingsButton.size.width / 2 + 15)
            self.addChild(settingsButton)
            
            // Fade in title image
            let fadeInAction = SKAction.fadeIn(withDuration: 1.0)
            titleImage.run(fadeInAction)
            
            // Scale animation for title image
            let scaleUp = SKAction.scale(to: 1.5, duration: 2.0)
            let scaleDown = SKAction.scale(to: 1.2, duration: 2.0)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            let repeatScale = SKAction.repeatForever(scaleSequence)
            //titleImage.run(repeatScale)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "startButton" {
                // Fade out title image before transitioning to game scene
                if let titleImage = self.childNode(withName: "titleImage") as? SKSpriteNode {
                    let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
                    let transitionAction = SKAction.run {
                        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                        let gameScene = GameScene(size: self.size)
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                    let sequence = SKAction.sequence([fadeOutAction, transitionAction])
                    titleImage.run(sequence)
                }
            } else if node.name == "settingsButton" {
                let overlay = SettingsOverlay(size: self.size)
                self.addChild(overlay)
                settingsOverlay = overlay
            } else if node.name == "closeButton" {
                settingsOverlay?.removeFromParent()
                settingsOverlay = nil
            }
        }
    }
}
