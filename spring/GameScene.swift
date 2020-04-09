//
//  GameScene.swift
//  spring
//
//  Created by Kevin on 3/16/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
	
	var spring = 0.0
	var damping = 0.0
	var height = 0.0
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode!
	private var Circle = SKShapeNode()
	private var staticSpringNode = SKShapeNode()
	private var dynSpringNode = SKShapeNode()

    override func sceneDidLoad() {
		spring = Double(UserDefaults.standard.float(forKey: "sl1"))
		damping = Double(UserDefaults.standard.float(forKey: "sl2"))
		height = Double(UserDefaults.standard.float(forKey: "sl3"))
		
        self.lastUpdateTime = 0
		
		Circle = SKShapeNode(circleOfRadius: 40)
		Circle.position = CGPoint.init(x: 0, y: height*500)
		print(height)
		Circle.name = "circle"
		Circle.fillColor = SKColor.red
		Circle.physicsBody = SKPhysicsBody(circleOfRadius: 40)
		Circle.physicsBody?.isDynamic = true
		Circle.physicsBody?.restitution = 1.0
		self.addChild(Circle)
		
		staticSpringNode = SKShapeNode(rect: CGRect(x: -150, y: -50, width: 300, height: 100))
		staticSpringNode.name = "springStat"
		staticSpringNode.fillColor = SKColor.white
		staticSpringNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 100))
		staticSpringNode.physicsBody?.isDynamic = false
		staticSpringNode.physicsBody?.affectedByGravity = false
		staticSpringNode.physicsBody?.restitution = 1.0
		staticSpringNode.position = CGPoint(x: 0, y: -500)
		self.addChild(staticSpringNode)
		
		dynSpringNode = SKShapeNode(rect: CGRect(x: -150, y: -50, width: 300, height: 100))
		dynSpringNode.name = "springDyn"
		dynSpringNode.fillColor = SKColor.blue
		dynSpringNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 100))
		dynSpringNode.position = CGPoint(x: 0, y: -300)
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
        
        self.lastUpdateTime = currentTime
    }
}
