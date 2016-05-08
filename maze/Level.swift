//
//  Level.swift
//  ball maze
//
//  Created by Ahmed masoud on 11/27/15.
//  Copyright © 2015 Ahmed masoud. All rights reserved.
//

import Foundation
import SpriteKit
var StarsToFinish:Int = 0
var FinishNodePos : CGPoint!

class Level : SKSpriteNode{
    var pauseLabel : SKLabelNode!
    
    init(){
        // vortexPos=[0]
        let size1 = CGSize(width: 32, height: 44)
        super.init(texture: nil, color: UIColor.clearColor(), size: size1)
        loadLevel(playerlevel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLevel(playerlevel : Int) {
        
        pauseLabel = SKLabelNode(fontNamed: "Chalkduster")
        pauseLabel.text = "||"
        pauseLabel.horizontalAlignmentMode = .Left
        pauseLabel.position = CGPoint(x: 980, y: 640)
        addChild(pauseLabel)
        
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        if let levelPath = NSBundle.mainBundle().pathForResource("level\(playerlevel)", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath, usedEncoding: nil) {
                let lines = levelString.componentsSeparatedByString("\n")
                
                for (row, line) in lines.reverse().enumerate() {
                    for (column, letter) in line.characters.enumerate() {
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                        
                        if letter == "x" {
                            // load wall
                            let node = SKSpriteNode(imageNamed: "block")
                            node.position = position
                            
                            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
                            //collision detection
                            node.physicsBody!.categoryBitMask = CollisionTypes.wall.rawValue

                            node.physicsBody!.dynamic = false
                            addChild(node)
                        } else if letter == "v"  {
                            // load vortex
                            let node = SKSpriteNode(imageNamed: "vortex")
                            node.name = "vortex"
                            node.position = position
                            node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            //
                            /*collision detection*/
                            node.physicsBody!.categoryBitMask = CollisionTypes.vortex.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            //
                            
                            addChild(node)
                            
                        } else if letter == "s"  {
                            // load star
                            StarsToFinish++
                            let node = SKSpriteNode(imageNamed: "star")
                            node.name = "star"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            //
                            /*collision detection*/
                            node.physicsBody!.categoryBitMask = CollisionTypes.star.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            //
                            node.position = position
                            addChild(node)
                        } else if letter == "f"  {
                            // load finish
                            var node = SKSpriteNode(imageNamed: "finish")
                            node.name = "finish"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            //
                            /*collision detection*/
                            node.physicsBody!.categoryBitMask = CollisionTypes.finish.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            //
                            node.position = position
                            addChild(node)
                            FinishNodePos = node.position
                            FinishNodePos.x = FinishNodePos.x+64
                            //
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
}
