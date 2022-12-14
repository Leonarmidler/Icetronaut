//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Leonardo Daniele on 06/12/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    //GAME SOUNDS
    
    //GAME PARAMETERS
    public var timeSpawn:CGFloat = 1.5
    public var timeMoveDistance:CGFloat = 1.5
    public var itemMoveDistance:CGFloat = 256// bgSample.frame.width = 256

    public let bgSample = SKSpriteNode(imageNamed: "bgSample")
    
    public var score = 0
    public var difficulty: Double = 1
    
    var isStarted = false
    var isPlayAgain = false
    var isJumping = false
    var isWaiting = true
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        gameStart()
        
    }
    
    func gameStart(){
        
        addDeadLine()
        addGround()
        addCeiling()
        addBackground()
        addPlayer()
        addScore()
        
        addSounds()
        
    }
    
    func addSounds(){
        
        let walkingSound = SKAudioNode(fileNamed: "walkingSound.mp3")
        
        walkingSound.name = "walkingSound"
        addChild(walkingSound)
        
    }
    
    func addPlayer() {
        
        let player = SKSpriteNode(imageNamed: "pistacchioidle1")
        
        player.setScale(1/4)
    
        player.anchorPoint = CGPoint(x: 0, y: 0)
        player.position = CGPoint(x: player.frame.width + 100, y: 120)
        player.zPosition = 2
                
        setPhysics(item: player)
        
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        
        player.name = "player"
        addChild(player)
        
    }
    
    func addGround() {
        
        let ground = SKSpriteNode(imageNamed: "ground")
        
        ground.anchorPoint = CGPoint(x: 0, y: 0)
        ground.position = CGPoint(x: 0, y: -20)
        ground.zPosition = -2
        
        setPhysics(item: ground)
        
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.pinned = true
        
        ground.name = "ground"
        addChild(ground)
        
    }
    
    func addDeadLine() {
        
        let deadLine = SKSpriteNode(imageNamed: "deadline")
        
        deadLine.position = CGPoint(x: -deadLine.frame.width, y: 0)
        deadLine.zPosition = 3
        
        deadLine.physicsBody?.affectedByGravity = false
        deadLine.physicsBody?.isDynamic = false
        deadLine.physicsBody?.allowsRotation = false
        deadLine.physicsBody?.pinned = true
        
        setPhysics(item: deadLine)
        
        deadLine.name = "deadline"
        addChild(deadLine)
    
    }
    
    func addCeiling() {
        
        let ceiling = SKSpriteNode(imageNamed: "ceiling")
        
        ceiling.anchorPoint = CGPoint(x: 0, y: 0)
        ceiling.position = CGPoint(x: 0, y: bgSample.frame.height)
        ceiling.zPosition = -2
        
        ceiling.name = "ceiling"
        addChild(ceiling)
        
    }
    
    func addBackground() {
        
        let bg = SKSpriteNode(imageNamed: "backgroundx6")
        
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.position = CGPoint(x: 0, y: frame.height/2 - bg.frame.height/2)
        bg.zPosition = -2
        
        bg.name = "bgx6"
        addChild(bg)
        
    }
    
    func addScore() {
        
        let scoreLabel = SKLabelNode(fontNamed: "GravityBold8")
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .black
        
        scoreLabel.position = CGPoint(x: frame.width/2, y: 5*frame.height/6)
        
        scoreLabel.name = "scoreLabel"
        addChild(scoreLabel)
        
    }
    
    func spawnBackground(){
        
        let bg = SKSpriteNode(imageNamed: "background\(Int.random(in: 1...3))")
        
        bg.setScale(1/5)
        
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.position = CGPoint(x: 4*bgSample.frame.width, y: frame.height/2-bgSample.frame.height/2)
        bg.zPosition = -1
        
        addChild(bg)
        moveItem(item: bg)
        
    }
    
    func spawnIcecream(){
    
        print("icecream")
        
        //SHELFS POSITIONS y:  115, 163, 235
        let icecream = SKSpriteNode(imageNamed: "icecream1")
        let yPosition = [115, 163, 235]
        
        icecream.setScale(1/5)
        
        icecream.anchorPoint = CGPoint(x: 0, y: 0)
        icecream.position = CGPoint(x: Int(4*bgSample.frame.width - icecream.frame.width/2) , y: yPosition.randomElement() ?? 0)
        icecream.physicsBody = SKPhysicsBody(rectangleOf: icecream.size)

        icecream.physicsBody?.isDynamic = false
        icecream.physicsBody?.allowsRotation = false
        icecream.physicsBody?.affectedByGravity = false
        
        moveItem(item: icecream)
        self.icAnimation(ic: icecream)
        
        icecream.name = "icecream"
        addChild(icecream)

    }
    
    func spawnPickle(){
        
        print("pickle")
        let pickle = SKSpriteNode(imageNamed: "picklejar1")
        let yPosition = [115, 163, 235]
        
        pickle.setScale(1/5)
        
        pickle.anchorPoint = CGPoint(x: 0, y: 0)
        pickle.position = CGPoint(x: Int(4*bgSample.frame.width - pickle.frame.width/2) , y: yPosition.randomElement() ?? 0)
        pickle.physicsBody = SKPhysicsBody(rectangleOf: pickle.size)

        pickle.physicsBody?.isDynamic = false
        pickle.physicsBody?.allowsRotation = false
        pickle.physicsBody?.affectedByGravity = false
        
        moveItem(item: pickle)
        self.pickleAnimation(pickle: pickle)
        
        pickle.name = "pickle"
        addChild(pickle)
        
    }
    
    func spawnSparkle(icPosition: CGPoint){
        
        let sparkle = SKSpriteNode(imageNamed: "sparkles1")
        
        sparkle.setScale(1/5)
        sparkle.anchorPoint = CGPoint(x: 0, y: 0)
        sparkle.position = icPosition
        sparkle.zPosition = 0
        
        let actionAnimation = SKAction.run {
            self.sparkleAnimation(sparkle: sparkle)
        }
        let actionWait = SKAction.wait(forDuration: 0.6)
        let actionRemove = SKAction.run {
            sparkle.removeFromParent()
        }
        let actionFadeOut = SKAction.fadeOut(withDuration: 0.4)
        
        addChild(sparkle)
        moveItem(item: sparkle)
        
        sparkle.run(SKAction.sequence([actionAnimation, actionWait, actionFadeOut, actionWait, actionRemove ]))
    }
    
}
