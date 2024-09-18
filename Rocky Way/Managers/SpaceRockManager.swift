//
//  PlanetManager.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/22/24.
//

import SpriteKit

class SpaceRockManager {
    var rocks: [SKSpriteNode] = []
    var rockTextures: [SKTexture] = []
    let rockImages = [
        "Space_Rock_1",
        "Space_Rock_2"
    ]
    
    func preloadTextures(completion: @escaping () -> Void) {
        let textures = rockImages.map { SKTexture(imageNamed:  $0) }
        SKTexture.preload(textures) {
            self.rockTextures = textures
            completion()
        }
    }
    
    func getRandomRockTexture() -> SKTexture {
        let randomIndex = Int(arc4random_uniform(UInt32(rockTextures.count)))
        return rockTextures[randomIndex]
    }
    
    func createRock(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        let rockTexture = getRandomRockTexture()
        let rock = SKSpriteNode(texture: rockTexture)

        // Set random initial rotation
        let randomRotation = CGFloat.random(in: 0..<CGFloat.pi / 3)
        rock.zRotation = randomRotation
        
        // Set rotation
        let speed = CGFloat.pi / 9
        let rotateAction = SKAction.rotate(byAngle: speed, duration: 1.0)
        let repeatRotateAction = SKAction.repeatForever(rotateAction)
        rock.run(repeatRotateAction)
        
        rock.position = CGPoint(x: CGFloat.random(in: 0...scene.size.width), y: scene.size.height + rock.size.height)
        rock.zPosition = 3
        
        // Custom physics body
        let rockPath = CGMutablePath()
        let width = rock.size.width / 2
        let height = rock.size.height / 2
        rockPath.addLines(between: [
            CGPoint(x: -width + 20, y: height - 20),
            CGPoint(x: -width + 20, y: -height + 20),
            CGPoint(x: width - 20, y: -height + 20),
            CGPoint(x: width - 20, y: height - 20),
        ])
        rockPath.closeSubpath()
        
        // Set up physics body
        let rockPhysicsBody = SKPhysicsBody(polygonFrom: rockPath)
        rock.physicsBody = rockPhysicsBody
        rock.physicsBody?.categoryBitMask = PhysicsCategory.rock
        rock.physicsBody?.contactTestBitMask = PhysicsCategory.rocket
        rock.physicsBody?.collisionBitMask = PhysicsCategory.none
        rock.physicsBody?.usesPreciseCollisionDetection = false
        rock.physicsBody?.isDynamic = true
        rock.physicsBody?.affectedByGravity = false
        
        // Add rock
        scene.addChild(rock)
        rocks.append(rock)
    }
    
    func moveRocks(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        for rock in rocks {
            rock.position.y -= 3.4
            rock.position.x -= 0.1
        }
        
        removeExpiredRocks(in: scene)
    }
    
    func removeExpiredRocks(in scene: SKScene) {
        for (index, rock) in rocks.enumerated().reversed() {
            if rock.position.y + rock.size.height < 0 {
                rock.removeFromParent()
                rocks.remove(at: index)
            }
        }
    }
    
    func startRocksMovement(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        let createAction = SKAction.run {
            [weak self] in
            self?.createRock(in: scene)
        }
        let waitAction = SKAction.wait(forDuration: 1.6)
        let createSequence = SKAction.sequence([createAction, waitAction])
        let createRepeatAction = SKAction.repeatForever(createSequence)
    
        scene.run(createRepeatAction, withKey: "createRocks")
    }
    
    func stopRocksMovement(in scene: SKScene) {
        scene.removeAction(forKey: "createRocks")
    }
    
    func update(in scene: SKScene) {
        moveRocks(in: scene)
    }
}
