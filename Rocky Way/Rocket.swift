//
//  Rocket.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/24/24.
//

import SpriteKit

class Rocket: SKSpriteNode {
    let margin: CGFloat = 5.0
    var fireEmitter: SKEmitterNode?
    
    init(safeAreaInsets: UIEdgeInsets, frame: CGRect) {
        let texture = SKTexture(imageNamed: "Rocket")
        let color = UIColor.clear
        let size = CGSize(width: 74, height: 112)
        super.init(texture: texture, color: color, size: size)
        self.color = .lightGray
        self.zPosition = 4
        
        // Position of the rocket should be towards bottom of screen
        let xPos = frame.midX
        let yPos = safeAreaInsets.bottom + size.height / 2 + margin + 15
        self.position = CGPoint(x: xPos, y: yPos)
        self.name = "Rocket"
        
        // Set up physics body
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.rocket
        self.physicsBody?.contactTestBitMask = PhysicsCategory.rock | PhysicsCategory.diamond
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        
        if let fireEmitter = SKEmitterNode(fileNamed: "RocketEngineFire") {
            fireEmitter.position = CGPoint(x: 0, y: -size.height / 2 - 5)
            fireEmitter.zPosition = 3
            self.addChild(fireEmitter)
            self.fireEmitter = fireEmitter
        }
        
        // Warning signal image
        let warningSignal = SKSpriteNode(imageNamed: "Warning_Signal")
        warningSignal.position = CGPoint(x: size.width / 2 + warningSignal.size.width / 2 - 10, y: size.height / 2 + warningSignal.size.height / 2 - 10)
        warningSignal.zPosition = 6
        warningSignal.isHidden = true
        self.addChild(warningSignal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMovingLeft() {
        let moveAction = SKAction.moveBy(x: -50, y: 0, duration: 0.2)
        let repeatAction = SKAction.repeatForever(moveAction)
        let rotateAction = SKAction.rotate(toAngle: CGFloat(30.0 * .pi/180), duration: 0.1, shortestUnitArc: true)
        let groupAction = SKAction.group([repeatAction, rotateAction])
        self.run(groupAction, withKey: "moveLeft")
    }
    
    func startMovingRight() {
        let moveAction = SKAction.moveBy(x: 50, y: 0, duration: 0.2)
        let repeatAction = SKAction.repeatForever(moveAction)
        let rotateAction = SKAction.rotate(toAngle: CGFloat(-30.0 * .pi/180), duration: 0.1, shortestUnitArc: true)
        let groupAction = SKAction.group([repeatAction, rotateAction])
        self.run(groupAction, withKey: "moveRight")
    }
    
    func stopMoving() {
        self.removeAction(forKey: "moveLeft")
        self.removeAction(forKey: "moveRight")
        let resetRotation = SKAction.rotate(toAngle: 0, duration: 0.1, shortestUnitArc: true)
        self.run(resetRotation)
    }
    
    func checkForBoundaries() {
        if let scene = self.scene {
            if position.x - size.width / 2 <= margin && action(forKey: "moveLeft") != nil {
                position.x = margin + size.width / 2
                stopMoving()
            } else if position.x + size.width / 2 >= scene.size.width - margin && action(forKey: "moveRight") != nil {
                position.x = scene.size.width - margin - size.width / 2
                stopMoving()
            }
        }
    }
}
