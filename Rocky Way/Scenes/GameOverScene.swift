//
//  GameOverScene.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/24/24.
//

import SpriteKit

class GameOverScene: SKScene {
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFill
        let gradientTexture = SKTexture(gradientColors: [UIColor(red: 29/255, green: 23/255, blue: 54/255, alpha: 1.0), UIColor(red: 110/255, green: 42/255, blue: 109/255, alpha: 1.0)], size: frame.size)
        let background = SKSpriteNode(texture: gradientTexture)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        self.addChild(background)
        
        let gameOverImage = SKSpriteNode(imageNamed: "Game_Over")
        gameOverImage.position = CGPoint(x: size.width / 2, y: size.height - 104)
        addChild(gameOverImage)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Marker felt"
        scoreLabel.fontSize = 37
        scoreLabel.fontColor = .systemPink
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(scoreLabel)
        
        let okButton = SKLabelNode(text: "OK")
        okButton.fontName = "Marker felt"
        okButton.fontSize = 30
        okButton.fontColor = .white
        okButton.position = CGPoint(x: size.width / 2, y: size.height * 1 / 10)
        okButton.name = "okButton"
        addChild(okButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "okButton" {
                let transition = SKTransition.fade(withDuration: 1.0)
                let startScene = StartScene(size: self.size)
                self.view?.presentScene(startScene, transition: transition)
            } 
        }
    }
}
