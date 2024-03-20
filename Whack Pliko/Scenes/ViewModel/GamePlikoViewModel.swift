//
//  GamePlikoViewModel.swift
//  Whack Pliko
//
//  Created by Anton on 13/3/24.
//

import Foundation
import SpriteKit

class GamePlikoViewModel {
    
    var scoreGaned: Int
    
    init(scoreGaned: Int) {
        self.scoreGaned = scoreGaned
    }
    
    let pegDimension: CGFloat = 20
    
    var ball: SKSpriteNode!
    
    private var pegs = [(CGFloat, CGFloat)]()
    
    func setPhysicBody(to scene: SKScene) {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    func setContactDelegate(to scene: SKScene, delegate: SKPhysicsContactDelegate) {
        scene.physicsWorld.contactDelegate = delegate
    }
    
    func setUpGame(to scene: SKScene) {
        drawBackground(scene: scene)
        drawBoard(scene: scene)
        drawPlikoDropBall(to: scene)
        addAllBonuses(to: scene)
    }
    
    private let bonuses = [PlikoNames.bonus_10, PlikoNames.bonus_4, PlikoNames.bonus_2, PlikoNames.bonus_0, PlikoNames.bonus_3, PlikoNames.bonus_5, PlikoNames.bonus_7]
    
    private func addAllBonuses(to scene: SKScene) {
        let width = scene.size.width
        let itemWidth = (Int(width) / bonuses.count) - 4
        for (index, bonus) in bonuses.enumerated() {
            var startX = 0
            if index == 0 {
                startX = 38
            } else {
                startX = itemWidth * index + 38
            }
            let y = CGFloat(itemWidth)
            let bonusItem = addBonusItem(to: scene, src: bonus, name: bonus, position: CGPoint(x: Double(startX), y: Double(y)))
            scene.addChild(bonusItem)
        }
    }
    
    private func addBonusItem(to scene: SKScene, src image: String, name bonus: String, position: CGPoint) -> SKSpriteNode {
        let width = scene.size.width
        let itemWidth = (Int(width) / bonuses.count) - 4
        
        let node = SKSpriteNode(imageNamed: image)
        node.position = position
        node.name = bonus
        node.size = CGSize(width: itemWidth, height: itemWidth)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = node.physicsBody?.collisionBitMask ?? 1
        return node
    }
    
    func collissionBetweenObjects(_ contact: SKPhysicsContact, in scene: SKScene) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == PlikoNames.ball {
        } else if nodeB.name == PlikoNames.ball {
            collissionBetween(ball: nodeB, object: nodeA, in: scene)
        }
    }
    
    private func collissionBetween(ball: SKNode, object: SKNode, in scene: SKScene) {
        if object.name == PlikoNames.bonus_0 {
            multiplyGanedScore(value: 0)
            destroyBall(ball: ball, in: scene)
        } else if object.name == PlikoNames.bonus_2 {
            multiplyGanedScore(value: 2)
            destroyBall(ball: ball, in: scene)
        } else if object.name == PlikoNames.bonus_3 {
            multiplyGanedScore(value: 3)
            destroyBall(ball: ball, in: scene)
        } else if object.name == PlikoNames.bonus_4 {
            multiplyGanedScore(value: 4)
            destroyBall(ball: ball, in: scene)
        } else if object.name == PlikoNames.bonus_5 {
            multiplyGanedScore(value: 5)
            destroyBall(ball: ball, in: scene)
        } else if object.name == PlikoNames.bonus_7 {
            multiplyGanedScore(value: 7)
            destroyBall(ball: ball, in: scene)
        }else if object.name == PlikoNames.bonus_10 {
            multiplyGanedScore(value: 10)
            destroyBall(ball: ball, in: scene)
        }
    }
    
    private func multiplyGanedScore(value multiply: Int) {
        scoreGaned *= multiply
        print("DATA SCORE total score \(scoreGaned) multiply in \(multiply) times")
        NotificationCenter.default.post(name: Notification.Name("MULTIPLY_BONUS"), object: nil, userInfo: ["totalScore": scoreGaned])
    }
    
    private func destroyBall(ball: SKNode, in scene: SKScene) {
        ball.removeFromParent()
    }
    
    private func drawPlikoDropBall(to scene: SKScene) {
        let node = SKSpriteNode(imageNamed: "pliko_drop_ball_symbol")
        let width = scene.size.width
        let height = scene.size.height
        node.size = CGSize(width: 30, height: 30)
        node.position.x = width / 2
        node.position.y = height - 40
        scene.addChild(node)
    }
    
    func dropBall(to scene: SKScene) {
        ball = SKSpriteNode(imageNamed: "pink_ball")
        let width = scene.size.width
        let height = scene.size.height
        ball.size = CGSize(width: 12, height: 12)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 1
        ball.physicsBody?.restitution = 0.25
        ball.position.x = width / 2 + CGFloat(Int.random(in: (-20)...(20)))
        ball.position.y = height - 40
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        ball.name = PlikoNames.ball
        scene.addChild(ball)
    }
    
    private func drawBackground(scene: SKScene) {
        let background = SKSpriteNode(imageNamed: "pliko_bg")
        background.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 240)
        background.blendMode = .replace
        background.zPosition = -1
        background.size = CGSize(width: UIScreen.main.bounds.width, height: 460)
        // addMusic(to: background, for: .back)
        scene.addChild(background)
    }
    
    private func drawBoard(scene: SKScene) {
        let width = scene.size.width
        let height = CGFloat(640)
        let numRows = 7 // Number of rows
        
        let pexSize = pegDimension * 1.7
        let centerPoint = width / 2 + pexSize / 2
        
        pegs = []
        for row in 1..<(numRows + 2) {
            let pegsCount = row
            if pegsCount > 1 {
                let totalWidth = CGFloat(pegsCount) * pexSize
                let startPointX = centerPoint - totalWidth / 2
                let startPointY = ((pexSize) * CGFloat(row - 2) - 30) - (height / 2)
                
                for peg in 0..<pegsCount {
                    let x = startPointX + CGFloat(peg) * pexSize
                    let y = startPointY
                    pegs.append((x, -y))
                    
                    let pegNode = SKSpriteNode(imageNamed: "pegImage")
                    pegNode.position = CGPoint(x: x, y: -y)
                    pegNode.size = CGSize(width: 15, height: 15)
                    pegNode.name = PlikoNames.peg
                    pegNode.physicsBody = SKPhysicsBody(circleOfRadius: pegNode.size.width / 2)
                    pegNode.physicsBody?.isDynamic = false
                    scene.addChild(pegNode)
                }
            }
        }
    }
    
}
