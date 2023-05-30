//
//  GameAnimations.swift
//  SpriteKitTest
//
//  Created by Leonardo Daniele on 08/12/22.
//

import UIKit
import SpriteKit
import GameplayKit

extension GameScene {
    
    func runAnimation() {
        
        let runTextures = [
            SKTexture(imageNamed: "pistacchiowalking1"),
            SKTexture(imageNamed: "pistacchiowalking2"),
            SKTexture(imageNamed: "pistacchiowalking3"),
            SKTexture(imageNamed: "pistacchiowalking4")
        ]
        
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let loopRun = SKAction.repeatForever(runAnimation)
        
        childNode(withName: "player")!.run(loopRun)
        childNode(withName: "walkingSoung")?.run(SKAction.play())
        
    }
    
    func jumpAnimation() {
        
        let jumpTextures = [
            SKTexture(imageNamed: "pistacchiojump1"),
            SKTexture(imageNamed: "pistacchiojump2"),
            SKTexture(imageNamed: "pistacchiojump3"),
            SKTexture(imageNamed: "pistacchiojump4")
        ]
        
        let jumpAnimation = SKAction.animate(with: jumpTextures, timePerFrame: 0.3)
        
        childNode(withName: "player")!.run(jumpAnimation)
        
    }
    
    func idleAnimation() {
        
        let idleTextures = [
            SKTexture(imageNamed: "pistacchioidle1"),
            SKTexture(imageNamed: "pistacchioidle2")
        ]
        
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.4)
        let loopIdle = SKAction.repeatForever(idleAnimation)
        
        childNode(withName: "player")?.run(loopIdle)
        
    }
    
    func icAnimation(ic: SKSpriteNode){
        let idleTextures = [
            SKTexture(imageNamed: "icecream11"),
            SKTexture(imageNamed: "icecream12"),
            SKTexture(imageNamed: "icecream13"),
            SKTexture(imageNamed: "icecream14")
        ]
        
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.2)
        let loopIdle = SKAction.repeatForever(idleAnimation)
        
        ic.run(loopIdle)
    }
    
    func pickleAnimation(pickle: SKSpriteNode){
        let idleTextures = [
            SKTexture(imageNamed: "picklejar11"),
            SKTexture(imageNamed: "picklejar12"),
            SKTexture(imageNamed: "picklejar13"),
            SKTexture(imageNamed: "picklejar14")
        ]
        
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.2)
        let loopIdle = SKAction.repeatForever(idleAnimation)
        
        pickle.run(loopIdle)
    }
    
    func moveBackground(bg: SKSpriteNode) {
        
        let actionMove = SKAction.moveBy(x: -bgSample.frame.width*6, y: 0, duration: timeMoveDistance*6)
        let actionRemove = SKAction.removeFromParent()
        
        bg.run(SKAction.sequence([actionMove, actionRemove]))
        
    }
    
    func moveItem(item: SKSpriteNode){
    
        if item.position.x > -3*bgSample.frame.width {
            let actionMove = SKAction.moveBy(x: -bgSample.frame.width, y: 0, duration: (timeMoveDistance*difficulty))
            item.run(SKAction.sequence([actionMove, SKAction.run{self.moveItem(item: item)}]))
        } else {
            item.removeFromParent()
        }
        
    }
    
    func sparkleAnimation(sparkle: SKSpriteNode){
        
        let sparkleTexture = [
            SKTexture(imageNamed: "sparkles1"),
            SKTexture(imageNamed: "sparkles2"),
            SKTexture(imageNamed: "sparkles3")
        ]
        
        let sparkleAnimation = SKAction.animate(with: sparkleTexture, timePerFrame: 0.1)
        
        sparkle.run(sparkleAnimation)

    }
    
}
