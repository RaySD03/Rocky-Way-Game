//
//  DiamondManager.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/25/24.
//

import SpriteKit

enum DiamondType: String {
    case blue
    case green
}

class DiamondManager {
    var diamonds: [SKSpriteNode] = []
    let diamondImages = [
        "Blue_Diamond",
        "Green_Diamond",
    ]
    
    func getRandomDiamondImage() -> (String, DiamondType) {
        let randomValue = Int(arc4random_uniform(100))
        let imageName: String
        let type: DiamondType
        
        if randomValue < 90 { // 80% change for blue diamond
            imageName = "Blue_Diamond"
            type = .blue
        } else {
            imageName = "Green_Diamond"
            type = .green
        }
        
        return (imageName, type)
    }
    
    func createDiamond(in scene: SKScene, avoiding rocks: [SKSpriteNode]) {
        guard !GameManager.shared.paused else { return }
        
        let (diamondImage, diamondType) = getRandomDiamondImage()
        let diamondTexture = SKTexture(imageNamed: diamondImage)
        let diamond = SKSpriteNode(texture: diamondTexture)
        
        var position: CGPoint
        repeat {
            position = CGPoint(x: CGFloat.random(in: diamond.size.width / 2...(scene.size.width - diamond.size.width / 2)),
                               y: scene.size.height + diamond.size.height)
        } while rocks.contains(where: { $0.frame.intersects(diamond.frame) })
                    
        diamond.userData = NSMutableDictionary()
        diamond.userData?.setValue(diamondType.rawValue, forKey: "type")
        diamond.position = position
        diamond.zPosition = 2
        
        // Custom physics body (square box fits the diamond)
        let diamondContainer = CGMutablePath()
        let width = diamond.size.width / 2
        let height = diamond.size.height / 2
        diamondContainer.addLines(between: [
            CGPoint(x: -width, y: height),
            CGPoint(x: -width, y: -height),
            CGPoint(x: width, y: -height),
            CGPoint(x: width, y: height),
        ])
        diamondContainer.closeSubpath()
        
        // Set up physics body
        let diamondPhysicsBody = SKPhysicsBody(polygonFrom: diamondContainer)
        diamond.physicsBody = diamondPhysicsBody
        diamond.physicsBody?.categoryBitMask = PhysicsCategory.diamond
        diamond.physicsBody?.contactTestBitMask = PhysicsCategory.rocket
        diamond.physicsBody?.collisionBitMask = PhysicsCategory.none
        diamond.physicsBody?.usesPreciseCollisionDetection = false
        diamond.physicsBody?.isDynamic = true
        diamond.physicsBody?.affectedByGravity = false
        
        // Add flipping animation
        let flipRight = SKAction.run { diamond.xScale = -1.0 }
        let flipLeft = SKAction.run { diamond.xScale = 1.0 }
        let flipSequence = SKAction.sequence([flipRight, SKAction.wait(forDuration: 0.2), flipLeft, SKAction.wait(forDuration: 0.2)])
        let repeatFlipAction = SKAction.repeatForever(flipSequence)
        diamond.run(repeatFlipAction)
        
        scene.addChild(diamond)
        diamonds.append(diamond)
    }
    
    func moveDiamonds(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        for diamond in diamonds {
            diamond.position.y -= 3.3
        }
        
        removeExpiredDiamonds(in: scene)
    }
    
    func removeExpiredDiamonds(in scene: SKScene) {
        for (index, diamond) in diamonds.enumerated().reversed() {
            if diamond.position.y + diamond.size.height < 0 {
                diamond.removeFromParent()
                diamonds.remove(at: index)
                //print("Removed diamond at \(index)")
            }
        }
    }
    
    func startDiamondsMovement(in scene: SKScene, avoiding rocks: [SKSpriteNode]) {
        guard !GameManager.shared.paused else { return }
        
        let createAction = SKAction.run {
            [weak self] in
            self?.createDiamond(in: scene, avoiding: rocks)
        }
        let waitAction = SKAction.wait(forDuration: 3.6)
        let createSequence = SKAction.sequence([createAction, waitAction])
        let createRepeatAction = SKAction.repeatForever(createSequence)
        
        scene.run(createRepeatAction, withKey: "createDiamonds")
    }
    
    func stopSpawningDiamonds(in scene: SKScene) {
        scene.removeAction(forKey: "createDiamonds")
    }
    
    func update(in scene: SKScene) {
        moveDiamonds(in: scene)
    }
}
