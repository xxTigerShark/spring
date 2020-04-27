//
//  GameScene.swift
//  spring
//
//  Created by Kevin on 3/16/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	let cam = SKCameraNode()
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	var collisionOccured = false
	var collisionCleared = false
	
	var spring = 0.0
	var damping = 0.0
	var height = 0.0
	
	private var initialSet = 0.0
	private var pos = [Double]()
	
	private var initialSetC = 0.0
	private var posC = [Double]()
	
	private var lastUpdateTime : TimeInterval = 0
	private var label : SKLabelNode!
	private var Circle = SKShapeNode()
	private var staticSpringNode = SKShapeNode()
	private var dynSpringNode = SKShapeNode()
	private var lines = [SKShapeNode]()
	
	// Loads GameScene
	override func sceneDidLoad() {
		// Sets camera
		self.camera = cam
		
		// Sets physcs
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.81)
		
		// Sets values
		spring = Double(UserDefaults.standard.float(forKey: "sl1"))
		damping = Double(UserDefaults.standard.float(forKey: "sl2"))
		height = Double(UserDefaults.standard.float(forKey: "sl3"))
		
		// Sets emergency close timer from a unending system
		_ = Timer.scheduledTimer(timeInterval: height/10 + 4.0, target: self, selector: #selector(good), userInfo: nil, repeats: true)
		
		self.physicsWorld.contactDelegate = self
		
		self.lastUpdateTime = 0
		
		// Sets up circle
		Circle = SKShapeNode(circleOfRadius: 40)
		Circle.position = CGPoint.init(x: 0, y: height*500)
		print(height)
		Circle.name = "circle"
		Circle.fillColor = SKColor.red
		Circle.physicsBody = SKPhysicsBody(circleOfRadius: 40)
		Circle.physicsBody?.isDynamic = true
		Circle.physicsBody?.friction = 0.0
		Circle.physicsBody?.allowsRotation = true
		Circle.physicsBody?.restitution = 1.0
		Circle.physicsBody?.mass = 4.0
		Circle.physicsBody?.usesPreciseCollisionDetection = true
		Circle.physicsBody!.contactTestBitMask = Circle.physicsBody!.collisionBitMask
		initialSetC = Double(Circle.position.y)
		Circle.run(SKAction.repeatForever(SKAction.rotate(byAngle: 3.14, duration: 0.5)))
		self.addChild(Circle)
		
		// Sets up lower spring
		staticSpringNode = SKShapeNode(rect: CGRect(x: -150, y: -50, width: 500, height: 100))
		staticSpringNode.name = "springStat"
		staticSpringNode.fillColor = SKColor.white
		staticSpringNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 100))
		staticSpringNode.physicsBody?.isDynamic = false
		staticSpringNode.physicsBody?.affectedByGravity = false
		staticSpringNode.physicsBody?.restitution = 1.0
		staticSpringNode.position = CGPoint(x: 0, y: -700)
		staticSpringNode.physicsBody?.usesPreciseCollisionDetection = true
		self.addChild(staticSpringNode)
		
		// Sets up dynamic spring
		dynSpringNode = SKShapeNode(rect: CGRect(x: 0, y: -300, width: 300, height: 100))
		dynSpringNode.name = "springDyn"
		dynSpringNode.fillColor = SKColor.white
		dynSpringNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 100))
		dynSpringNode.position = CGPoint(x: 0, y: -300)
		dynSpringNode.physicsBody?.mass = 2.0
		dynSpringNode.physicsBody?.restitution = 1.0
		initialSet = Double(dynSpringNode.position.y)
		dynSpringNode.physicsBody!.contactTestBitMask = dynSpringNode.physicsBody!.collisionBitMask
		dynSpringNode.physicsBody?.usesPreciseCollisionDetection = true
		self.addChild(dynSpringNode)
		
		// Sets up space lines
		var good = false
		var currentY = -100
		var i = 0
		while good == false
		{
			lines.append(SKShapeNode(rect: CGRect(x: -150, y: -50, width: 3, height: Int.random(in: 50...150))))
			lines[i].name = "line"
			lines[i].fillColor = SKColor.white
			lines[i].physicsBody?.isDynamic = false
			lines[i].physicsBody?.affectedByGravity = false
			
			lines[i].position = CGPoint(x: Int.random(in: -400...400), y: currentY)
			lines[i].physicsBody?.usesPreciseCollisionDetection = true
			lines[i].zPosition = -500
			self.addChild(lines[i])
			
			currentY += Int.random(in: 250...400)
			
			if currentY > Int(Circle.position.y - 400)
			{
				good = true
			}
			i += 1
		}
		
		// Establishes spring physics
		let spr = SKPhysicsJointSpring.joint(withBodyA: staticSpringNode.physicsBody!, bodyB: dynSpringNode.physicsBody!, anchorA: staticSpringNode.position, anchorB: dynSpringNode.position)
		spr.damping = CGFloat(damping)*0.95
		spr.frequency = CGFloat(spring)
		self.physicsWorld.add(spr)
	}
	
	// Controls touch down for Sparks and surprise
	func touchDown(atPoint pos : CGPoint) {
		let touchedNode = self.atPoint(pos)
		if let name = touchedNode.name
		{
			if name == Circle.name
			{
				print("Touched 1")
				let text = SKTexture(imageNamed: "Image")
				Circle.fillTexture = text
				Circle.fillColor = UIColor.white
								
				let burstPath = Bundle.main.path(forResource: "Spark",
												 ofType: "sks")
				
				let burstNode = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!)
					as! SKEmitterNode
				
				burstNode.position = CGPoint(x: Circle.position.x, y: Circle.position.y)
				burstNode.numParticlesToEmit = 500
				burstNode.zPosition = -250
				self.addChild(burstNode)
			}
		}
	}
	
	// Handles moving touches
	// Does nothing
	func touchMoved(toPoint pos : CGPoint) {
		let touchedNode = self.atPoint(pos)
		if let name = touchedNode.name
		{
			if name == Circle.name
			{
				print("Touched 2")
			}
		}
	}
	
	// Closes window when closed button is pressed.
	func touchUp(atPoint pos : CGPoint) {
		let touchedNode = self.atPoint(pos)
		
		if let name = touchedNode.name
		{
			if name == "label"
			{
				print("Close Pressed")
				//NotificationCenter.default.post(name: Notification.Name(rawValue: "close"), object: nil)
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
	
	// Updates the frame
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
		
		// Updates upper spring physic and appends new data to the position array.
		// Also checks for completion of simulation
		
		self.enumerateChildNodes(withName: "springDyn")
		{
			node, stop in
			if (node is SKShapeNode)
			{
				let sprite = node as! SKShapeNode
				if self.collisionOccured == true
				{
					self.pos.append(Double(sprite.position.y) - self.initialSet)
				}
				
				// Need confirmation collision occured, velocity is zero, and 1 cycle of timer completed.
				if self.collisionOccured == true && sprite.physicsBody?.velocity == CGVector(dx: 0, dy: 0) && self.collisionCleared == true
				{
					self.complete()
					print("complete")
				}
			}
		}
		
		// Updates circle
		self.enumerateChildNodes(withName: "circle")
		{
			node, stop in
			if (node is SKShapeNode)
			{
				// Appends new elements to circle position array
				let sprite = node as! SKShapeNode
				if self.collisionOccured == true
				{
					self.posC.append(Double(sprite.position.y) - self.initialSet)
				}
				
				// Updates camera position
				self.cam.position = sprite.position
				
				// Need confirmation collision occured, velocity is zero, and 1 cycle of timer completed.
				if self.collisionOccured == true && sprite.physicsBody?.velocity == CGVector(dx: 0, dy: 0) && self.collisionCleared == true
				{
					self.complete()
					print("complete")
				}
			}
		}
		
		// Makes close label follow path
		self.enumerateChildNodes(withName: "label")
		{
			node, stop in
			if (node is SKLabelNode)
			{
				let sprite = node as! SKLabelNode
				sprite.position.x = self.cam.position.x - 170
				sprite.position.y = self.cam.position.y + 500
			}
		}
		
		self.lastUpdateTime = currentTime
	}
	
	// Calls upon completion of experiment.
	@objc func complete()
	{
		if collisionOccured == true
		{
			print("Processing")
			
			UserDefaults.standard.set(pos, forKey: "pos")
			UserDefaults.standard.set(posC, forKey: "posC")
			
			collisionOccured = false
			
			NotificationCenter.default.post(name: Notification.Name(rawValue: "next1"), object: nil)
			
			var sceneToLoad:SKScene?
			sceneToLoad = GameOver(fileNamed: "GameOver")
			
			if let scene = sceneToLoad {
				
				scene.size = size
				scene.scaleMode = scaleMode
				let transition = SKTransition.crossFade(withDuration: 0.25)
				self.view?.presentScene(scene, transition: transition)
			}
		}
	}

	// Called upon collision between circle and upper dynamic spring
	// Is not called with lower dynamic spring and thus does not need to verify.
	func didBegin(_ contact: SKPhysicsContact) {
		collisionOccured = true
		print("Collision")
		UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") + 10, forKey: "coins")
		
		let burstPath = Bundle.main.path(forResource: "Spark",
										 ofType: "sks")
		
		let burstNode = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!)
			as! SKEmitterNode
		
		burstNode.position = CGPoint(x: Circle.position.x, y: Circle.position.y)
		burstNode.numParticlesToEmit = 500
		burstNode.zPosition = -250
		self.addChild(burstNode)
	}

	// Clears from timer if collision is good.
	@objc func good()
	{
		collisionCleared = true
		print("Cleared")
	}
}
