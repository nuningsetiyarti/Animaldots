//
//  GameScene.swift
//  Nano3_ConnectDots
//
//  Created by Griffin on 11/06/20.
//  Copyright © 2020 Griffin. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory{
    static let whale: UInt32 = 0b1 //0001 = 1
    static let dot2: UInt32 = 0b10 //0010 = 2
    static let dot3: UInt32 = 0b10 //0010 = 2
}

class GameScene: SKScene {
    
    var whale: SKSpriteNode!
    
    var dot1: SKSpriteNode!
    var dot2: SKSpriteNode!
    
    var changeColor: SKAction!
    
    var touched:Bool = false
    var location = CGPoint.zero
    var sfx: SKAudioNode!
    
    override func didMove(to view: SKView) {
        print("warna ganti")
        changeDotColor()
        
        whale = childNode(withName: "Whale") as! SKSpriteNode
        dot1 = childNode(withName: "Dot2") as! SKSpriteNode
        dot2 = childNode(withName: "Dot3") as! SKSpriteNode
    
        physicsWorld.contactDelegate = self
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        for touch in touches {
            location = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       for touch in touches {
           location = touch.location(in: self)
       }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (touched) {
            moveNodeToLocation()
        }
    }
    
    func moveNodeToLocation() {
        // Compute vector components in direction of the touch
        var dx = location.x - whale.position.x
        var dy = location.y - whale.position.y
        // How fast to move the node. Adjust this as needed
        let speed:CGFloat = 0.25
        // Scale vector
        dx = dx * speed
        dy = dy * speed
        whale.position = CGPoint(x:whale.position.x+dx, y:whale.position.y+dy)
    }
    
    func changeDotColor() {
        var textures: SKTexture
        textures = SKTexture(imageNamed: "dotyellow")
        
        changeColor = SKAction.setTexture(textures)
        print("warna ganti")
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("masuk contact")
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.dot2 | PhysicsCategory.whale{
            
            //print(contact.bodyA.node?.name)
            //print(contact.bodyB.node?.name)
            let node = contact.bodyA.node?.name == "Whale" ? contact.bodyB.node : contact.bodyA.node
            
            print(node?.name)
            
            node?.physicsBody?.contactTestBitMask = 0
            node?.run(changeColor)
        }
    }

}
