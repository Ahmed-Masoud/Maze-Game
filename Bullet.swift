//
//  Bullet.swift
//  maze
//
//  Created by Ahmed masoud on 12/1/15.
//  Copyright © 2015 Ahmed masoud. All rights reserved.
//

import Foundation
import SpriteKit
class Bullet:SKSpriteNode{
    var bullet : SKSpriteNode
    
    init(){
        bullet = SKSpriteNode(imageNamed: "bullet")
        let size1 = CGSize(width: 32, height: 44)
        super.init(texture: nil, color: UIColor.blackColor(), size: size1)
        //var bullet : SKSpriteNode
        bullet.position = CGPoint(x: 96, y: 672)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody!.allowsRotation = false
        bullet.physicsBody!.categoryBitMask = CollisionTypes.bullet.rawValue
        bullet.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
   }