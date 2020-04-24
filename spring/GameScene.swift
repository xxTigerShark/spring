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
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
	var collisionOccured = false
	
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

    override func sceneDidLoad() {
		
		_ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(complete), userInfo: nil, repeats: true)

		spring = Double(UserDefaults.standard.float(forKey: "sl1"))
		damping = Double(UserDefaults.standard.float(forKey: "sl2"))
		height = Double(UserDefaults.standard.float(forKey: "sl3"))
		
		self.physicsWorld.contactDelegate = self
		
        self.lastUpdateTime = 0
		
		Circle = SKShapeNode(circleOfRadius: 40)
		Circle.position = CGPoint.init(x: 0, y: height*500)
		print(height)
		Circle.name = "circle"
		Circle.fillColor = SKColor.red
		Circle.physicsBody = SKPhysicsBody(circleOfRadius: 40)
		Circle.physicsBody?.isDynamic = true
		Circle.physicsBody?.restitution = 0.0
		Circle.physicsBody?.mass = 4.0
		Circle.physicsBody?.usesPreciseCollisionDetection = true
		Circle.physicsBody!.contactTestBitMask = Circle.physicsBody!.collisionBitMask
		initialSetC = Double(Circle.position.y)
		self.addChild(Circle)
		
		staticSpringNode = SKShapeNode(rect: CGRect(x: -150, y: -50, width: 500, height: 100))
		staticSpringNode.name = "springStat"
		staticSpringNode.fillColor = SKColor.white
		staticSpringNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 100))
		staticSpringNode.physicsBody?.isDynamic = false
		staticSpringNode.physicsBody?.affectedByGravity = false
		staticSpringNode.physicsBody?.restitution = 0.0
		staticSpringNode.position = CGPoint(x: 0, y: -500)
		staticSpringNode.physicsBody?.usesPreciseCollisionDetection = true

		self.addChild(staticSpringNode)
		
		dynSpringNode = SKShapeNode(rect: CGRect(x: -150, y: -50, width: 300, height: 100))
		dynSpringNode.name = "springDyn"
		dynSpringNode.fillColor = SKColor.blue
		dynSpringNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 100))
		dynSpringNode.position = CGPoint(x: 0, y: -300)
		dynSpringNode.physicsBody?.mass = 2.0
		initialSet = Double(dynSpringNode.position.y)
		dynSpringNode.physicsBody!.contactTestBitMask = dynSpringNode.physicsBody!.collisionBitMask

		dynSpringNode.physicsBody?.usesPreciseCollisionDetection = true

		self.addChild(dynSpringNode)
		
		let spr = SKPhysicsJointSpring.joint(withBodyA: staticSpringNode.physicsBody!, bodyB: dynSpringNode.physicsBody!, anchorA: staticSpringNode.position, anchorB: dynSpringNode.position)
		spr.damping = CGFloat(damping)
		spr.frequency = CGFloat(spring)
		
		self.physicsWorld.add(spr)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
		let touchedNode = self.atPoint(pos)

		if let name = touchedNode.name
		{
			if name == "label"
			{
				print("Close Pressed")
				NotificationCenter.default.post(name: Notification.Name(rawValue: "close"), object: nil)

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
		
		self.enumerateChildNodes(withName: "springDyn")
		{
			node, stop in
			if (node is SKShapeNode)
			{
				let sprite = node as! SKShapeNode
				self.pos.append(Double(sprite.position.y) - self.initialSet)
				
				if self.collisionOccured == true && sprite.physicsBody?.velocity == CGVector(dx: 0, dy: 0)
				{
					self.complete()
					print("complete")
				}
			}
		}
		
		self.enumerateChildNodes(withName: "circle")
		{
			node, stop in
			if (node is SKShapeNode)
			{
				let sprite = node as! SKShapeNode
				self.posC.append(Double(sprite.position.y) - self.initialSet)

				if self.collisionOccured == true && sprite.physicsBody?.velocity == CGVector(dx: 0, dy: 0)
				{
					self.complete()
					print("complete")
				}
			}
		}
        
        self.lastUpdateTime = currentTime
    }
	
	@objc func complete()
	{
		if collisionOccured == true
		{
			print("Processing")

			UserDefaults.standard.set(pos, forKey: "pos")
			UserDefaults.standard.set(posC, forKey: "posC")

			collisionOccured = false

			NotificationCenter.default.post(name: Notification.Name(rawValue: "next1"), object: nil)
		}
	}
	
	
	func collisionBetween(ball: SKNode, object: SKNode) {
		if object.name == "circle" {
			collisionOccured = true
			print("Collision")
		}
		if ball.name == "circle" {
			collisionOccured = true
			print("Collision")
		}
	}
		
	func didBegin(_ contact: SKPhysicsContact) {
		collisionOccured = true
		print("Collision")
	}
}
