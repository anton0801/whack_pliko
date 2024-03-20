//
//  WhackSlotViewModel.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import Foundation
import SpriteKit

class WhackSlotViewModel {
    
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(_ node: SKNode) {
        let sprite = SKSpriteNode(imageNamed: SpriteName.whackHole)
        node.addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: SpriteName.whackMask)
        
        charNode = SKSpriteNode(imageNamed: SpriteName.ballGreen)
        charNode.position = CGPoint(x: 0, y: -90)
        cropNode.addChild(charNode)
        
        node.addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: SpriteName.ballGreen)
            charNode.name = SpriteName.ballGreen
        } else {
            charNode.texture = SKTexture(imageNamed: SpriteName.ballRed)
            charNode.name = SpriteName.ballRed
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.05)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
}
