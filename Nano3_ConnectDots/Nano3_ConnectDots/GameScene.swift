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
    var outline: SKSpriteNode!
    var swipe: SKSpriteNode!
    
    var dotConnected: Int = 0
    
    var changeColor: SKAction!
    
    var touched:Bool = false
    var location = CGPoint.zero
    var sfx: SKAudioNode!
    
    override func didMove(to view: SKView) {
         
        changeDotColor()
        
        whale = childNode(withName: "Whale") as! SKSpriteNode
        outline = childNode(withName: "Outline") as! SKSpriteNode
        swipe = childNode(withName: "Swipe") as! SKSpriteNode
        
        let swipeExample = SKAction.moveBy(x: 120, y:0, duration: 1.0)
        let swipeBackExample = SKAction.moveBy(x:-120, y:0, duration: 1.0)
        
        let swipeAnimation = SKAction.sequence([swipeExample, swipeBackExample])
        let swipeTutorial = SKAction.repeatForever(swipeAnimation)
        
        swipe.run(swipeTutorial)
        
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
        
        swipe.removeFromParent()
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
    
    func spawnAnimal() {
        print("finished!")
        let whaleFinish = SKSpriteNode(imageNamed: "whalebig")
        whaleFinish.setScale(1.5)
        whaleFinish.position = CGPoint(x: 800, y: 500)
        
        let whaleText = SKSpriteNode(imageNamed: "whaletext")
        whaleText.setScale(2.5)
        whaleText.position = CGPoint(x: 880, y: 100)
        
        let moveAction = SKAction.moveBy(x: -200, y:0, duration: 1.0)
        let movebackAction = SKAction.moveBy(x: 250, y: 0, duration: 1.0)
        
        addChild(whaleFinish)
        addChild(whaleText)
        whaleFinish.run(SKAction.sequence([moveAction, movebackAction]))
    }
    
    func changeDotColor() {
        var textures: SKTexture
        textures = SKTexture(imageNamed: "dotyellow")
        
        changeColor = SKAction.setTexture(textures)
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        
        //print("masuk contact")
        //var stringnode: String
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let soundAction = SKAction.playSoundFileNamed("positive10_zapsplat.mp3", waitForCompletion: true)
        let volumeAction = SKAction.changeVolume(to: 0.3, duration: 0)
//        let soundNode = SKAudioNode(fileNamed: "flaunch.wav")
//        soundNode.autoplayLooped = false
//
//        addChild(soundNode)
        
        if contactMask == PhysicsCategory.dot2 | PhysicsCategory.whale{
            
            if dotConnected >= 0 {
                let node = contact.bodyA.node?.name == "Whale" ? contact.bodyB.node : contact.bodyA.node
                
                
                print(node?.name)
                //stringnode = node!.name!
                //let newstring = stringnode.filter { "0"..."9" ~= $0 }
                
                if node?.name! == "Dot\(dotConnected+1)" {
                    node?.physicsBody?.contactTestBitMask = 0
                    node?.run(SKAction.group([soundAction, volumeAction, changeColor]))
                    //soundNode.run(SKAction.play())
                    
                    
                    dotConnected += 1
                }
                //soundNode.removeFromParent()
                //dotConnected = Int(newstring)!
                print("dotconnected = \(dotConnected)")
            }
            
            if dotConnected == 17 {
                //self.removeAllChildren()
//                let soundNode = SKAudioNode(fileNamed: "flaunch.wav")
//                soundNode.autoplayLooped = false
//                addChild(soundNode)
                let soundFinishAction = SKAction.playSoundFileNamed("watery_zapsplat.mp3", waitForCompletion: true)
                let waitAction = SKAction.wait(forDuration: 1.5)
                
                run(SKAction.sequence([volumeAction, soundFinishAction, waitAction]))
                
                
                for child in 1...17 {
                   let x = childNode(withName: "Dot\(child)")
                    x?.removeFromParent()
                }
                
                //soundNode.run(SKAction.play())
                //soundNode.removeFromParent()
                whale.removeFromParent()
                outline.removeFromParent()
                
                spawnAnimal()
            }
            
            //print(contact.bodyA.node?.name)
            //print(contact.bodyB.node?.name)
            
            
        }
    }

}
