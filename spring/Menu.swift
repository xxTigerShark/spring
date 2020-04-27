//
//  Menu.swift
//  spring
//
//  Created by Kevin on 4/23/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import SpriteKit
import GameplayKit

class Menu: SKScene
{
	let cam = SKCameraNode()
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	var collisionOccured = false
	private var lastUpdateTime : TimeInterval = 0
	private var coinCount : Int = 0
	private var damp : Double = 0
	private var dampCost : Int = -100
	private var spri : Double = 0
	private var spriCost : Int = -100
	private var heig : Double = 0
	private var heigCost : Int = -100
	
	// Loads Scene
	override func sceneDidLoad() {
		// First launch settings
		if !UserDefaults.standard.bool(forKey: "first")
		{
			UserDefaults.standard.set(2, forKey: "sl1")
			UserDefaults.standard.set(0.0000, forKey: "sl2")
			UserDefaults.standard.set(10, forKey: "sl3")
			UserDefaults.standard.set(0, forKey: "coins")
			UserDefaults.standard.set(true, forKey: "first")
		}

		// Sets values from NSUserDefaults
		spri = Double(UserDefaults.standard.float(forKey: "sl1"))
		damp = Double(UserDefaults.standard.float(forKey: "sl2"))
		heig = Double(UserDefaults.standard.float(forKey: "sl3"))
		coinCount = UserDefaults.standard.integer(forKey: "coins")
	}
	
	// Button touch up
	// Controls play and allows use of currency
	func touchUp(atPoint pos : CGPoint) {
		let touchedNode = self.atPoint(pos)
		
		if let name = touchedNode.name
		{
			if name == "Play"
			{
				print("Play Pressed")
				var sceneToLoad:SKScene?
				sceneToLoad = GameScene(fileNamed: "GameScene")
				
				if let scene = sceneToLoad {
					
					scene.size = size
					scene.scaleMode = scaleMode
					let transition = SKTransition.crossFade(withDuration: 0.25)
					self.view?.presentScene(scene, transition: transition)
				}
			}
			
			// Next 3 handle purchasing
			if name == "buy1"
			{
				if UserDefaults.standard.integer(forKey: "coins") >= 100
				{
					UserDefaults.standard.set(UserDefaults.standard.float(forKey: "sl2") + 0.1, forKey: "sl2")
					damp = damp + 0.1
					
					UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") - 100, forKey: "coins")
				}
			}
			if name == "buy2"
			{
				if UserDefaults.standard.integer(forKey: "coins") >= 100
				{
					UserDefaults.standard.set(UserDefaults.standard.float(forKey: "sl1") + 0.1, forKey: "sl1")
					spri = spri + 0.1
					UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") - 100, forKey: "coins")
				}
			}
			if name == "buy3"
			{
				if UserDefaults.standard.integer(forKey: "coins") >= 100
				{
					UserDefaults.standard.set(UserDefaults.standard.float(forKey: "sl3") + 10, forKey: "sl3")
					heig = heig + 10
					UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") - 100, forKey: "coins")
				}
			}
		}
	}
	
	func touchDown(atPoint pos : CGPoint) {
		
	}
	
	func touchMoved(toPoint pos : CGPoint) {
		
	}
	
	// Handles touches
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
	
	
	// Updates frame
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
		
		// Updates the purchase frames
		self.enumerateChildNodes(withName: "buy1")
		{
			node, stop in
			if (node is SKLabelNode)
			{
				let sprite = node as! SKLabelNode
				let string = " for 100 coins"
				sprite.text = String(format: "+10 Damping (%.2f)", self.damp) + string
			}
		}
		
		self.enumerateChildNodes(withName: "buy2")
		{
			node, stop in
			if (node is SKLabelNode)
			{
				let sprite = node as! SKLabelNode
				let string = " for 100 coins"
				sprite.text = String(format: "+10 Spring (%.2f)", self.spri) + string
			}
		}
		
		self.enumerateChildNodes(withName: "buy3")
		{
			node, stop in
			if (node is SKLabelNode)
			{
				let sprite = node as! SKLabelNode
				let string = " for 100 coins"
				sprite.text = String(format: "+10 Height (%.0f)", self.heig) + string
				
			}
		}
		
		self.enumerateChildNodes(withName: "coin")
		{
			node, stop in
			if (node is SKLabelNode)
			{
				let sprite = node as! SKLabelNode
				sprite.text = String(format: "Coins: %d", UserDefaults.standard.integer(forKey: "coins"))
			}
		}
		
		self.lastUpdateTime = currentTime
	}
}
