//
//  File.swift
//  spring
//
//  Created by Kevin on 4/24/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: SKScene
{
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	private var lastUpdateTime : TimeInterval = 0
	private var coinCount : Int = 0
	
	override func sceneDidLoad() {
		coinCount = UserDefaults.standard.integer(forKey: "coins")
	}
	
	func touchUp(atPoint pos : CGPoint) {
		let touchedNode = self.atPoint(pos)
		
		if let name = touchedNode.name
		{
			if name == "Menu"
			{
				print("Menu Pressed")
				var sceneToLoad:SKScene?
				sceneToLoad = Menu(fileNamed: "Menu")
				
				if let scene = sceneToLoad {
					
					scene.size = size
					scene.scaleMode = scaleMode
					let transition = SKTransition.crossFade(withDuration: 0.25)
					self.view?.presentScene(scene, transition: transition)
				}
			}
		}
	}
	
	func touchDown(atPoint pos : CGPoint) {
		
	}
	
	func touchMoved(toPoint pos : CGPoint) {
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		
		// Initialize _lastUpdateTime if it has not already been
		if (self.lastUpdateTime == 0) {
			self.lastUpdateTime = currentTime
		}
		
		// Calculate time since last update
		let dt = currentTime - self.lastUpdateTime
		
		// Update entities
		for entity in self.entities {
			entity.update(deltaTime: dt)
		}
		
		self.enumerateChildNodes(withName: "coin")
		{
			node, stop in
			if (node is SKLabelNode)
			{
				let sprite = node as! SKLabelNode
				sprite.text = String(format: "%d coins in the bank", UserDefaults.standard.integer(forKey: "coins"))
			}
		}
		
		self.lastUpdateTime = currentTime
	}
}
