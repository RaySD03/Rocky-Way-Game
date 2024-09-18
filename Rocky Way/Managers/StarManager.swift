//
//  StarManager.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/22/24.
//

import SpriteKit

class StarManager {
    var stars: [SKSpriteNode] = []
    var starTextures: [SKTexture] = []
    let starImages = [
        "Star_1",
        "Star_2",
        "Star_3",
        "Star_4",
        "Star_5",
        "Star_6",
        "Star_7"
    ]
    
    func preloadTextures(completion: @escaping () -> Void) {
        let textures = starImages.map { SKTexture(imageNamed:  $0) }
        SKTexture.preload(textures) {
            self.starTextures = textures
            completion()
        }
    }
    
    func getRandomStarImage() -> SKTexture {
        let randomIndex = Int(arc4random_uniform(UInt32(starTextures.count)))
        return starTextures[randomIndex]
    }
    
    func createStar(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        let starTexture = getRandomStarImage()
        let star = SKSpriteNode(texture: starTexture)
            
        star.zPosition = 0
        star.position = CGPoint(x: CGFloat.random(in: 0...scene.size.width), y: scene.size.height + star.size.height)

        scene.addChild(star)
        stars.append(star)
    }
    
    func moveStars(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        for star in stars {
            star.position.y -= 3.4
        }
        
        removeExpiredStars(in: scene)
    }
    
    func removeExpiredStars(in scene: SKScene) {
        for (index, star) in stars.enumerated().reversed() {
            if star.position.y + star.size.height < 0 {
                star.removeFromParent()
                stars.remove(at: index)
            }
        }
    }
    
    func startStarsMovement(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        let createAction = SKAction.run {
            [weak self] in
            self?.createStar(in: scene)
        }
        let waitAction = SKAction.wait(forDuration: 0.2)
        let createSequence = SKAction.sequence([createAction, waitAction])
        let createRepeatAction = SKAction.repeatForever(createSequence)
        
        scene.run(createRepeatAction, withKey: "createStars")
    }
    
    func stopStarsMovement(in scene: SKScene) {
        scene.removeAction(forKey: "createStars")
    }
    
    func update(in scene: SKScene) {
        moveStars(in: scene)
    }
}
