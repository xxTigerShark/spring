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
		
		// Establishes NotificationCenter posts
		NotificationCenter.default.addObserver(self, selector: #selector(close), name: Notification.Name(rawValue: "close"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(moveOn), name: Notification.Name(rawValue: "next1"), object: nil)

        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "Menu") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! Menu? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
				
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = false
                    view.showsNodeCount = false
					view.showsPhysics = false
                }
            }
        }
    }

	// Disables auto rotate
    override var shouldAutorotate: Bool {
        return false
    }

	// Sets rotation requirments
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
			return .portrait
        } else {
			return .portraitUpsideDown
        }
    }

	// Hides status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
	
	// Calls a closing of the window
	@objc func close()
	{
		self.dismiss(animated: true, completion: nil)
	}
	
	
	// Pushes to view for charts
	@objc func moveOn()
	{
		print("pushing")
		
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let vc = storyBoard.instantiateViewController(withIdentifier: "chart") as! ChartsViewController
			self.present(vc, animated: true, completion: nil)
	}
}
