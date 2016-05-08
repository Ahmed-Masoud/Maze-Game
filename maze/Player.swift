//
//  Player.swift
//  ball maze
//
//  Created by Ahmed masoud on 11/27/15.
//  Copyright © 2015 Ahmed masoud. All rights reserved.
//

import Foundation
import SpriteKit

class Player:SKSpriteNode{
    var player : SKSpriteNode!
    init(){
        let size1 = CGSize(width: 32, height: 44)
        super.init(texture: nil, color: UIColor.clearColor(), size: size1)
        createPlayer()
    }
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.linearDamping = 0.5
        
        //collision
        player.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        player.physicsBody!.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody!.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


