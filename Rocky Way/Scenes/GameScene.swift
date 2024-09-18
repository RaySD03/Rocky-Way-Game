//
//  GameScene.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/24/24.
//

import SpriteKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let rocket: UInt32 = 0x1 << 0
    static let rock: UInt32 = 0x1 << 1
    static let diamond: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var rocket: Rocket!
    var starManager = StarManager()
    var planetManager = PlanetManager()
    var spaceRockManager = SpaceRockManager()
    var diamondManager = DiamondManager()
    var scoreLabel: SKLabelNode!
    var scoreValueLabel: SKLabelNode!
    var pauseOverlay: SKNode?
    var scoreManager: ScoreManager!
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFill
        physicsWorld.contactDelegate = self
        view.showsPhysics = true
        
        let safeArea = self.view?.safeAreaInsets ?? .zero
            
        // Setup pause button
        self.setupPauseButton(safeArea: safeArea)
            
        // Setup score labels
        self.setupScoreLabels(safeArea: safeArea)
            
        // Setup rocket
        self.rocket = Rocket(safeAreaInsets: safeArea, frame: self.frame)
        self.addChild(self.rocket)
        
        // Set game background gradient color
        let gradientTexture = SKTexture(gradientColors: [.black, UIColor(red: 45/255, green: 63/255, blue: 70/255, alpha: 1.0)], size: frame.size)
        let background = SKSpriteNode(texture: gradientTexture)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        self.addChild(background)
        
        // Start scrolling stars
        self.starManager.preloadTextures {
            print("Star Textures Preloaded")
            self.starManager.startStarsMovement(in: self)
        }
        
        // Start scrolling planets
        self.planetManager.preloadTextures {
            print("Planet Textures Preloaded")
            self.planetManager.startPlanetsMovement(in: self)
        }
        
        // Start scrolling space rocks
        let delay = SKAction.wait(forDuration: 1.5)
        let startRockManager = SKAction.run {
            self.spaceRockManager.preloadTextures {
                print("Rock Textures Preloaded")
                self.spaceRockManager.startRocksMovement(in: self)
            }
        }
        let sequence = SKAction.sequence([delay, startRockManager])
        self.run(sequence)
        
        // Start spawning diamonds
        self.diamondManager.startDiamondsMovement(in: self, avoiding: self.spaceRockManager.rocks)
        
        // Initialize ScoreManager
        scoreManager = ScoreManager(scoreLabel: scoreValueLabel, gameScene: self)
    }
    
    func setupScoreLabels(safeArea: UIEdgeInsets) {
        scoreLabel = SKLabelNode(text: "Score:")
        scoreLabel.position = CGPoint(x: 20 + safeArea.left, y: size.height - 40 - safeArea.top)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontName = "Marker felt"
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 28
        scoreLabel.zPosition = 50
        addChild(scoreLabel)
        
        scoreValueLabel = SKLabelNode(text: "0")
        scoreValueLabel.position = CGPoint(x: 20 + safeArea.left, y: size.height - 72 - safeArea.top)
        scoreValueLabel.horizontalAlignmentMode = .left
        scoreValueLabel.fontName = "Courier"
        scoreValueLabel.fontColor = .white
        scoreValueLabel.fontSize = 28
        scoreValueLabel.zPosition = 50
        addChild(scoreValueLabel)
    }
    
    func setupPauseButton(safeArea: UIEdgeInsets) {
        let pauseButton = SKSpriteNode(imageNamed: "Pause_Button")
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.position = CGPoint(x: self.size.width - 40 - safeArea.right, y: self.size.height - 40 - safeArea.top)
        pauseButton.name = "pauseButton"
        pauseButton.zPosition = 99
        self.addChild(pauseButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "pauseButton" {
                GameManager.shared.pauseGame(in: self)
            } else if node.name == "resumeLabel" {
                GameManager.shared.resumeGame()
            } else if node.name == "quitLabel" {
                GameManager.shared.quitGame()
            } else {
                // Move the rocket left or right
                if location.x < frame.midX {
                    rocket.startMovingLeft()
                } else {
                    rocket.startMovingRight()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rocket.stopMoving()
    }
        
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        rocket.stopMoving()
    }
    
    override func update(_ currentTime: TimeInterval) {
        starManager.moveStars(in: self)
        planetManager.movePlanets(in: self)
        spaceRockManager.moveRocks(in: self)
        diamondManager.moveDiamonds(in: self)
        rocket.checkForBoundaries()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
            if collision == PhysicsCategory.rocket | PhysicsCategory.rock {
                gameOver()
            } else if collision == PhysicsCategory.rocket | PhysicsCategory.diamond {
                if let diamond = contact.bodyB.node as? SKSpriteNode, diamond.physicsBody != nil {
                    // Remove physics body to prevent further detection (repeated frames)
                    diamond.physicsBody = nil
                    
                    // Determine diamond type and update the score accordingly
                    if let typeString = diamond.userData?.value(forKey: "type") as? String, let type = DiamondType(rawValue: typeString) {
                        // Increment the score
                        scoreManager.incrementScore(for: type)
                    }
                    
                    // Fade out and remove diamond
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([fadeOut, remove])
                    diamond.run(sequence)
                }
            }
    }
    
    func gameOver() {
        let transition = SKTransition.fade(withDuration: 1.0)
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.score = scoreManager.getScore()
        self.view?.presentScene(gameOverScene, transition: transition)
    }
}
