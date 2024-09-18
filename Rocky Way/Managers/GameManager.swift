//
//  GameManager.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/24/24.
//

import SpriteKit

class GameManager {
    static let shared = GameManager()
    
    private init() {}
    
    var currentGameScene: GameScene?
    var pauseOverlay: SKNode?
    var paused: Bool = false
    
    func pauseGame(in scene: GameScene) {
        paused = true
        scene.isPaused = true
        currentGameScene = scene
        
        pauseOverlay = PauseOverlay(size: scene.size)
        
        if let pauseOverlay = pauseOverlay {
            scene.addChild(pauseOverlay)
        }
    }
    
    func resumeGame() {
        paused = false
        guard let scene = currentGameScene else { return }
        scene.isPaused = false
        pauseOverlay?.removeFromParent()
        pauseOverlay = nil
    }
    
    func quitGame() {
        paused = false
        guard let scene = currentGameScene else { return }
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        let startScene = StartScene(size: scene.size)
        scene.view?.presentScene(startScene, transition: transition)
        currentGameScene = nil
        pauseOverlay = nil
    }
}
