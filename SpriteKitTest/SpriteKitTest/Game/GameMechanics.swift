//
//  GameMechanics.swift
//  SpriteKitTest
//
//  Created by Leonardo Daniele on 11/12/22.
//

import UIKit
import SwiftUI
import SpriteKit
import GameplayKit

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPlayAgain{
            if !isStarted{
                
                isStarted = true
                runAnimation()
                moveBackground(bg: childNode(withName: "bgx6") as! SKSpriteNode)
                randomSpawnBackground()
                randomChoose()
                
            } else {
                if isOnGround {
                    childNode(withName: "player")?.removeAllActions()
                    childNode(withName: "walkingSound")?.run(SKAction.stop())
                    jump()
                    
                    isOnGround = false
                    isJumping = true
                } else {
                    if isJumping{
                        childNode(withName: "player")?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        childNode(withName: "player")?.removeAllActions()
                        childNode(withName: "walkingSound")?.run(SKAction.stop())
                        jump()
                        isJumping = false
                    }
                }
            }
        } else {
            //self.removeAllActions()
            self.removeAllChildren()
        
            score = 0
            isPlayAgain = false
            isStarted = false
            gameStart()
        }
    }

    
    func pressToStart() {
        idleAnimation()
    }
    
    func jump() {
        //jumpAnimation()
        childNode(withName: "player")!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
    }
    
    func checkCollision(){
        if CGRectIntersectsRect(childNode(withName: "player")!.frame, childNode(withName: "icecream")!.frame){
            childNode(withName: "icecream")!.removeFromParent()
            childNode(withName: "scoreLabel")!.removeFromParent()
            score += 1
            addScore()
        }
    }
    
    func randomChoose(){
        let choice = Int.random(in: 1...2)
        
        if choice == 1 {
            randomSpawnPickle()
        } else if choice == 2 {
            randomSpawnIcecream()
        }
    }
    
    func randomSpawnPickle(){
        let spawn = SKAction.run {self.spawnPickle()}
        let sequence = SKAction.sequence([spawn, self.waitTime(), SKAction.run{self.randomChoose()}])
        self.run(sequence)
    }
    
    func randomSpawnIcecream(){
        let spawn = SKAction.run {self.spawnIcecream()}
        let sequence = SKAction.sequence([spawn, self.waitTime(), SKAction.run{self.randomChoose()}])
        self.run(sequence)
    }
    
    func randomSpawnBackground(){
        let actionSpawn = SKAction.run {self.spawnBackground()}
        let sequence = SKAction.sequence([actionSpawn, self.waitTime(), SKAction.run{self.randomSpawnBackground()}])
        self.run(sequence)
    }
    
    func waitTime() -> SKAction{
        let waitTime = timeSpawn*difficulty
        let actionWait = SKAction.wait(forDuration: waitTime)
    
        return actionWait
    }
    
    func gameOver() {

        let gameOver = SKLabelNode(fontNamed: "GravityBold8")
        let yourScore = SKLabelNode(fontNamed: "GravityBold8")
        
        gameOver.text = "GAME OVER"
        gameOver.fontSize = 40
        gameOver.fontColor = .white
        
        yourScore.text = "Your score: \(score)"
        yourScore.fontSize = 40
        yourScore.fontColor = .white
        
        gameOver.position = CGPoint(x: frame.width/2, y: frame.height/2+gameOver.frame.height)
        yourScore.position = CGPoint(x: frame.width/2, y: frame.height/2-yourScore.frame.height)
        
        addChild(gameOver)
        addChild(yourScore)
        
        difficulty = 1
        isJumping = false
        isStarted = false
        isPlayAgain = true
        isOnGround = true
        playAgain()
        
    }
    
    func playAgain(){
        
        let playAgain = SKLabelNode(fontNamed: "GravityBold8")
        
        playAgain.text = "Click to play"
        playAgain.fontSize = 20
        playAgain.fontColor = .white
        
        playAgain.position = CGPoint(x: frame.width/2, y: frame.height/6)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        let fade = SKAction.sequence([fadeOut, fadeIn])
        
        addChild(playAgain)
        playAgain.run(SKAction.repeatForever(fade))
        
        
    }
    
    func setDifficulty(){
        
        switch score {
        case 10: difficulty = 0.8
        case 20: difficulty = 0.6
        case 30: difficulty = 0.5
        case 100: difficulty = 0.4
        default:
            self.run(SKAction.wait(forDuration: timeSpawn*difficulty))
        }
        
    }
    
    func setPhysics(item: SKSpriteNode){
        item.physicsBody = SKPhysicsBody(rectangleOf: item.size)
        item.physicsBody?.contactTestBitMask = item.physicsBody?.collisionBitMask ?? 0
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        setDifficulty()
        if childNode(withName: "player")?.zRotation != 0 {
            childNode(withName: "player")?.zRotation = 0
        }
        childNode(withName: "player")?.position.x = childNode(withName: "player")!.frame.width + 100
        childNode(withName: "deadline")?.zRotation = 0
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "icecream" || contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "icecream"{
            
            if contact.bodyA.node!.name == "icecream" {
                self.spawnSparkle(icPosition: contact.bodyA.node!.position)
                contact.bodyA.node?.removeFromParent()
            } else if contact.bodyB.node?.name == "icecream"{
                self.spawnSparkle(icPosition: contact.bodyB.node!.position)
                contact.bodyB.node?.removeFromParent()
            }

            score += 1
            childNode(withName: "scoreLabel")!.removeFromParent()
            addScore()
        }
        
        if isStarted {
            if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "ground" || contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "ground" {
                isOnGround = true
                isJumping = false
                childNode(withName: "player")!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                runAnimation()
            }
            if contact.bodyA.node?.name == "icecream" && contact.bodyB.node?.name == "deadline" || contact.bodyB.node?.name == "icecream" && contact.bodyA.node?.name == "deadline" {

                self.removeAllChildren()
                self.removeAllActions()
                gameOver()

            }
            if contact.bodyA.node?.name == "pickle" && contact.bodyB.node?.name == "deadline" || contact.bodyB.node?.name == "pickle" && contact.bodyA.node?.name == "deadline" {
                childNode(withName: "pickle")?.removeFromParent()
            }
            if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "pickle" || contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "pickle"{
                
                self.removeAllChildren()
                self.removeAllActions()
                gameOver()
                
            }
        }
    }
        
}

struct PhysicsCategory {
    static let none   : UInt32 = 0
    static let playerCategory : UInt32 = 0b1
    static let groundCategory : UInt32 = 0b10
    static let icecreamCategory : UInt32 = 1
    static let deadlineCategory : UInt32 = 0b11
}
