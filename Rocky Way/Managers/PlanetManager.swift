//
//  PlanetManager.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/22/24.
//

import SpriteKit

class PlanetManager {
    var planets: [SKSpriteNode] = []
    var planetTextures: [SKTexture] = []
    let planetImages = [
        "Planet_1",
        "Planet_2",
        "Planet_3",
        "Planet_4"
    ]
    
    func preloadTextures(completion: @escaping () -> Void) {
        let textures = planetImages.map { SKTexture(imageNamed:  $0) }
        SKTexture.preload(textures) {
            self.planetTextures = textures
            completion()
        }
    }
    
    func getRandomPlanetImage() -> SKTexture {
        let randomIndex = Int(arc4random_uniform(UInt32(planetTextures.count)))
        return planetTextures[randomIndex]
    }
    
    func createPlanet(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        let planetTexture = getRandomPlanetImage()
        let planet = SKSpriteNode(texture: planetTexture)
            
        planet.zPosition = 1
        planet.position = CGPoint(x: CGFloat.random(in: 0...scene.size.width), y: scene.size.height + planet.size.height)
        //planet.setScale(1.4)

        scene.addChild(planet)
        planets.append(planet)
    }
    
    func movePlanets(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        for planet in planets {
            planet.position.y -= 3.5
        }
        removeExpiredPlanets(in: scene)
    }
    
    func removeExpiredPlanets(in scene: SKScene) {
        for (index, planet) in planets.enumerated().reversed() {
            if planet.position.y + planet.size.height < 0 {
                planet.removeFromParent()
                planets.remove(at: index)
            }
        }
    }
    
    func startPlanetsMovement(in scene: SKScene) {
        guard !GameManager.shared.paused else { return }
        
        let createAction = SKAction.run {
            [weak self] in
            self?.createPlanet(in: scene)
        }
        let waitAction = SKAction.wait(forDuration: 4.4)
        let createSequence = SKAction.sequence([createAction, waitAction])
        let createRepeatAction = SKAction.repeatForever(createSequence)
        
        scene.run(createRepeatAction, withKey: "createPlanets")
    }
    
    func stopStarsMovement(in scene: SKScene) {
        scene.removeAction(forKey: "createPlanets")
    }
    
    func update(in scene: SKScene) {
        movePlanets(in: scene)
    }
}
