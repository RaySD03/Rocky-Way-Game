//
//  GameViewController.swift
//  Rocky Way
//
//  Created by Raymond Babayan on 7/24/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = StartScene(size: view.bounds.size)
            
            // Set the scale mode to scale to resize to the window
            scene.scaleMode = .resizeFill
                
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
