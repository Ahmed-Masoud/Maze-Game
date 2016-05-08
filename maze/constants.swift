//
//  constants.swift
//  ball maze
//
//  Created by Ahmed masoud on 11/27/15.
//  Copyright © 2015 Ahmed masoud. All rights reserved.
//

import Foundation
import SpriteKit

enum CollisionTypes : UInt32{
    case Player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case bullet = 32
}
var vortexPos : [CGPoint] = [CGPointMake(0, 0)]
var playerlevel : Int = 1




