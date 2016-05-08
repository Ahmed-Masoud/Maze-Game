//
//  ActuallGame.swift
//  maze
//
//  Created by Ahmed masoud on 12/1/15.
//  Copyright © 2015 Ahmed masoud. All rights reserved.
//

import CoreMotion
import SpriteKit
import AudioToolbox
import AVFoundation
var BlockingNode:SKNode!
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var pos : CGPoint!
    var bullet : Bullet!
    //var bullet:SKSpriteNode!
    //var player : Player!
    var player : SKSpriteNode!
    var pauseLabel : SKLabelNode!
    var level : Level!
    var motionmanager :CMMotionManager!
    var scoreLabel : SKLabelNode!
    var gameOver = false
    
    var gameIsPaused = false
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    let fokakAudio = NSBundle.mainBundle().pathForResource("fokak", ofType: "m4a")
    var soundPlayer:AVAudioPlayer = AVAudioPlayer()
    
    func startLevel(){
        level = Level()
        addChild(level)
        let startNode = nodeAtPoint(CGPointMake(frame.width/2 - 7*64, frame.height/2 + 2*64))
         BlockingNode = nodeAtPoint(FinishNodePos)
        let BlockEnd = SKAction.moveTo(CGPointMake(FinishNodePos.x-64, FinishNodePos.y), duration: 2)
        let start = SKAction.moveTo(CGPointMake(startNode.position.x+64, startNode.position.y), duration: 3)
        
        startNode.runAction(start)
        //BlockingNode.runAction(BlockEnd)
    }
    var lastTouchPosition: CGPoint?
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        do{
            soundPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: fokakAudio!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
        
        
        
        startLevel()
        //player = Player()
        //addChild(player)
        createPlayer()
        
        physicsWorld.contactDelegate = self
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPoint(x: 350, y: 640)
        addChild(scoreLabel)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        motionmanager = CMMotionManager()
        motionmanager.startAccelerometerUpdates()
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*hijack accelerometer*/
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            let pauselocation = CGPointMake(980, 640)
            var deltax = location.x - pauselocation.x
            if deltax<0{
                deltax = deltax * -1
            }
            var deltay = location.y - pauselocation.y
            if deltay<0{
                deltay = deltax * -1
            }
            if (( deltax < 20)&&(deltay < 20)){
                //pause menu should appear
                if gameIsPaused == false{
                    pauseLabel = SKLabelNode(fontNamed: "Chalkduster")
                    pauseLabel.color = UIColor.blackColor()
                    pauseLabel.text = "Tap To Resume"
                    pauseLabel.horizontalAlignmentMode = .Left
                    pauseLabel.position = CGPointMake(frame.width/2 - 2*64, frame.height/2)
                    
                    addChild(pauseLabel)
                    gameIsPaused = true
                    let seconds = 0.01
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        // here code perfomed with delay
                        self.view?.paused = true
                        
                    })
                    
                    
                    
                    
                }
                return
            }
            if gameIsPaused == true{
                pauseLabel.removeFromParent()
                self.view?.paused = false
                gameIsPaused = false
            }
            
        }
        
        
    }
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*hijack accelerometer*/
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            lastTouchPosition = location
        }
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*hijack accelerometer*/
        lastTouchPosition = nil
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        /*hijack accelerometer*/
        lastTouchPosition = nil
    }
    
    func playerCollidedWithNode(node: SKNode) {
        
        if node.name == "vortex" {
            soundPlayer.play()
            player.physicsBody!.dynamic = false
            gameOver = true
            score = 0
            //uncomment fokaaaaaaak
            //playerlevel = 1
            
            let move = SKAction.moveTo(node.position, duration: 0.25)
            let scale = SKAction.scaleTo(0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.runAction(sequence) { [unowned self] in
                
                self.level.runAction(remove)
                self.startLevel()
                self.createPlayer()
                
                self.gameOver = false
            }
        } else if node.name == "star" {
            var temppos = scoreLabel.position
            temppos.x += 130
            let move = SKAction.moveTo(temppos, duration: 0.25)
            let scale = SKAction.scaleTo(0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            node.runAction(sequence)
            let seconds = 0.475
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                
                // here code perfomed with delay
                self.score++
                
            })
            
            
        } else if node.name == "finish" {
            // next level
            
                playerlevel++;
                player.physicsBody!.dynamic = false
                let move = SKAction.moveTo(node.position, duration: 0.25)
                let scale = SKAction.scaleTo(0.0001, duration: 0.25)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([move, scale, remove])
                player.runAction(sequence) { [unowned self] in
                    self.level.runAction(remove)
                    self.startLevel()
                    self.createPlayer()
                    
                    self.gameOver = false
                }
                
            
            
            
            
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            playerCollidedWithNode(contact.bodyB.node!)
        } else if contact.bodyB.node == player {
            playerCollidedWithNode(contact.bodyA.node!)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!gameOver){
                        /*hijack accelerometer*/
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
            
            /*accelerometer*/
            if let accelerometerData = motionmanager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -12.5, dy: accelerometerData.acceleration.x * 12.5)
            }
            bullet = Bullet()
            addChild(bullet)
                    }
        
        
        
    }
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.linearDamping = 0.5
        //
        /*collision*/
        
        player.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        player.physicsBody!.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody!.collisionBitMask = CollisionTypes.wall.rawValue
        //
        addChild(player)
    }
    
}

