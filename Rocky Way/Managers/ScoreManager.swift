//
//  ScoreManager.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/27/24.
//

import SpriteKit

class ScoreManager {
    weak var gameScene: SKScene?
    private var score: Int = 0
    private var scoreLabel: SKLabelNode
    private var multiplierImage: SKSpriteNode?
    private var isMultiplierActive: Bool = false
    
    init(scoreLabel: SKLabelNode, gameScene: SKScene) {
        self.scoreLabel = scoreLabel
        self.gameScene = gameScene
        updateScoreLabel()
    }
    
    func incrementScore(for diamondType: DiamondType) {
        var points = 0
        switch diamondType {
        case .blue:
            points = 5
        case .green:
            points = 10
            activateMutiplier()
        }
        
        if isMultiplierActive {
            points *= 2
        }
        
        score += points
        updateScoreLabel()
    }
    
    func resetScore() {
        score = 0
        updateScoreLabel()
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    func getScore() -> Int {
        return score
    }
    
    func activateMutiplier() {
        guard let scene = gameScene else { return }
        
        if multiplierImage == nil {
            isMultiplierActive = true
            
            let image = SKSpriteNode(imageNamed: "2x_Multiplier")
            image.position = CGPoint(x: -image.size.width, y: scene.size.height - 120 - (scene.view?.safeAreaInsets.top ?? 0))
            image.zPosition = 50
            image.size = CGSize(width: 56, height: 56)
            scene.addChild(image)
            multiplierImage = image
            
            let overlay = createOverlay(for: image)
            image.addChild(overlay)
            
            let slideIn = SKAction.moveTo(x: 48 + (scene.view?.safeAreaInsets.left
                                                   ?? 0), duration: 0.5)
            let wait = SKAction.wait(forDuration: 10.0)
            let slideOut = SKAction.moveTo(x: -image.size.width, duration: 0.5)
            let remove = SKAction.run {
                [weak self] in
                self?.isMultiplierActive = false
                self?.multiplierImage?.removeFromParent()
                self?.multiplierImage = nil
            }
            let sequence = SKAction.sequence([slideIn, wait, slideOut,remove])
            image.run(sequence)
        }
    }
    
    private func createOverlay(for image: SKSpriteNode) -> SKShapeNode {
        let radius = image.size.width / 2
        let overlay = SKShapeNode(circleOfRadius: radius)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.7)
        overlay.strokeColor = .clear
        overlay.zPosition = 1
        
        let startPath = UIBezierPath()
        startPath.move(to: .zero)
        startPath.addLine(to: CGPoint(x: 0, y: radius))
        
        overlay.path = startPath.cgPath
        
        let animation = SKAction.customAction(withDuration: 10.0) { node, elapsedTime in
            let percentage = elapsedTime / 10.0
            let endAngle = CGFloat.pi / 2 + CGFloat.pi * 2 * percentage
            let path = UIBezierPath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 0, y: radius))
            path.addArc(withCenter: .zero, radius: radius, startAngle: CGFloat.pi / 2, endAngle: endAngle, clockwise: true)
            path.addLine(to: .zero)
            overlay.path = path.cgPath
        }
        
        overlay.run(animation)
        
        return overlay
    }
}
