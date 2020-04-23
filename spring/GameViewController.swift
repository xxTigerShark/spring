//
//  GameViewController.swift
//  spring
//
//  Created by Kevin on 3/16/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(close), name: Notification.Name(rawValue: "close"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(moveOn), name: Notification.Name(rawValue: "next1"), object: nil)

        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
				
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
					view.showsPhysics = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
	
	@objc func close()
	{
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func moveOn()
	{
		print("pushing")
		
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let vc = storyBoard.instantiateViewController(withIdentifier: "chart") as! ChartsViewController
			self.present(vc, animated: true, completion: nil)
	}
}
