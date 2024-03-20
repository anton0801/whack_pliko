//
//  WhackGameViewModel.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import Foundation
import SpriteKit

class WhackGameViewModel {
    
    var gameId = UUID().uuidString
    var gameScore: SKLabelNode!
    var gainnedScore: Scorable = ProgressGame(score: 0) {
        didSet {
            gameScore.text = "\(gainnedScore.score)"
        }
    }
    var progressGame: Scorable = ProgressGame(score: UserDefaults.standard.integer(forKey: "score")) {
        didSet {
            gameScore.text = "\(progressGame.score)"
        }
    }
    
    var closeBtnSpriteNode: SKSpriteNode!
    var rulesBtn: SKSpriteNode!
    
    var slots: [WhackSlot] = []
    var popupTime = 0.85
    
    var numRounds = 0
    var maxRounds = 30
    
    func createScene(_ scene: SKScene) {
        addBackground(scene)
        addScoreLabel(scene)
        createSlots(scene)
        createCloseBtn(scene)
        createRulesBtn(scene)
    }
    
    func createCloseBtn(_ scene: SKScene) {
        let width = scene.size.width
        let height = scene.size.height
        closeBtnSpriteNode = SKSpriteNode(imageNamed: "close")
        closeBtnSpriteNode.position = CGPoint(x: width / 2, y: 65)
        closeBtnSpriteNode.name = "close_btn"
        scene.addChild(closeBtnSpriteNode)
    }
    
    func createRulesBtn(_ scene: SKScene) {
        rulesBtn = SKSpriteNode(imageNamed: "rules_2")
        rulesBtn.position = CGPoint(x: 60, y: UIScreen.main.bounds.height - 120)
        rulesBtn.name = "rules_btn"
        scene.addChild(rulesBtn)
    }
    
    private func addBackground(_ scene: SKScene) {
        let background = SKSpriteNode(imageNamed: SpriteName.whackBackground)
        background.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        background.name = SpriteName.whackBackground
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.addChild(background)
        
        // game slots bg
        let slotsBg = SKSpriteNode(imageNamed: SpriteName.slotBackground)
        slotsBg.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 30)
        slotsBg.blendMode = .replace
        slotsBg.zPosition = -1
        slotsBg.size = CGSize(width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.height - 290)
        slotsBg.name = SpriteName.slotBackground
        scene.addChild(slotsBg)
    }
    
    private func addScoreLabel(_ scene: SKScene) {
        let height = scene.size.height
        let scoreBgNode = SKSpriteNode(imageNamed: "points_bg")
        scoreBgNode.zPosition = -1
        scoreBgNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: height - 120)
        
        let moneyIconNode = SKSpriteNode(imageNamed: "money")
        moneyIconNode.zPosition = -1
        moneyIconNode.position = CGPoint(x: UIScreen.main.bounds.width / 2 - scoreBgNode.size.width / 2 + 40, y: height - 80 - scoreBgNode.size.height / 2)
        
        gameScore = SKLabelNode(fontNamed: "Inter")
        gameScore.fontSize = 22
        gameScore.text = "0"
        gameScore.zPosition = 1
        gameScore.position = CGPoint(x: UIScreen.main.bounds.width / 2 - scoreBgNode.size.width / 2 + 70 + moneyIconNode.size.width, y: height - 90 - scoreBgNode.size.height / 2)
        
        scene.addChild(scoreBgNode)
        scene.addChild(moneyIconNode)
        scene.addChild(gameScore)
    }
    
    private func createSlots(_ scene: SKScene) {
        let height = scene.size.height
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 60 + (i * 70), y: Int(height) / 2 + 70), in: scene)
        }
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 90 + (i * 70), y: Int(height) / 2), in: scene)
        }
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 60 + (i * 70), y: Int(height) / 2 - 60), in: scene)
        }
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 90 + (i * 70), y: Int(height) / 2 - 120), in: scene)
        }
//        for i in 0..<5 {
//            createSlot(at: CGPoint(x: 100 + (i * 170), y: 230), in: scene)
//        }
//        for i in 0..<4 {
//            createSlot(at: CGPoint(x: 180 + (i * 170), y: 140), in: scene)
//        }
    }
    
    private func createSlot(at position: CGPoint, in scene: SKScene) {
        let slot = WhackSlot(at: position)
        scene.addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy(with delay: Double, in scene: SKScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy(in: scene)
        }
    }
    
    private func createEnemy(in scene: SKScene) {
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].viewModel.show(hideTime: popupTime)
        if Int.random(in: 0...12) > 4 { slots[1].viewModel.show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].viewModel.show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].viewModel.show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].viewModel.show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        let delay = Double.random(in: minDelay...maxDelay)
        
        addCountRoundForFinishGame(scene)
        if numRounds < maxRounds {
            createEnemy(with: delay, in: scene)
        }
    }
    
    func hitBall(_ touches: Set<UITouch>, in scene: SKScene) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: scene)
        let tappedNodes = scene.nodes(at: location)
        
        guard !tappedNodes.contains(closeBtnSpriteNode) else {
            NotificationCenter.default.post(name: Notification.Name("CLOSE_GAME"), object: nil)
            return
        }       
        
        guard !tappedNodes.contains(rulesBtn) else {
            NotificationCenter.default.post(name: Notification.Name("RULES_GAME"), object: nil)
            return
        }
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { return }
            if !whackSlot.viewModel.isVisible { continue }
            if whackSlot.viewModel.isHit { continue }
            whackSlot.viewModel.hit()
            
            if node.name == SpriteName.ballGreen {
                whackSlot.viewModel.charNode.xScale = 0.85
                whackSlot.viewModel.charNode.yScale = 0.85
                gainnedScore.score += 10
                scene.run(SKAction.playSoundFileNamed("clickGood", waitForCompletion: false))
                
                if let smoke = SKEmitterNode(fileNamed: "Smoke") {
                    smoke.position = whackSlot.position
                    scene.addChild(smoke)
                }
            } else if node.name == SpriteName.ballRed {
                if progressGame.score >= 5 {
                    gainnedScore.score -= 5
                }
                scene.run(SKAction.playSoundFileNamed("clickBad", waitForCompletion: false))
                
                if let smoke = SKEmitterNode(fileNamed: "Smoke") {
                    smoke.position = whackSlot.position
                    scene.addChild(smoke)
                }
            }
        }
    }
    
    func addCountRoundForFinishGame(_ scene: SKScene) {
        numRounds += 1
//        let widht = scene.size.width
//        let height = scene.size.height
        
        if numRounds >= maxRounds {
            for slot in slots {
                slot.viewModel.hide()
            }
            
            NotificationCenter.default.post(name: Notification.Name("GAME_OVER"), object: nil, userInfo: ["data": gainnedScore.score, "gameId": gameId])
            
//            let gameOver = SKSpriteNode(imageNamed: SpriteName.gameOver)
//            gameOver.position = CGPoint(x: widht / 2, y: height / 2)
//            gameOver.zPosition = 1
//            gameOver.size = CGSize(width: 200, height: 100)
//            scene.addChild(gameOver)
//            let gameOverAction = SKAction.move(to: CGPoint(x: widht / 2, y: height / 2), duration: 1)
//            gameOver.run(gameOverAction)
//            
//            let scoreGameOver = SKLabelNode(text: "Your winning score is: \(gainnedScore.score)")
//            scoreGameOver.fontSize = 22
//            scoreGameOver.position = CGPoint(x: widht / 2, y: -50)
//            scoreGameOver.zPosition = 1
//            scene.addChild(scoreGameOver)
//            let scoreGameOverAction = SKAction.move(to: CGPoint(x: widht / 2, y: height / 2 - 40), duration: 1)
//            scoreGameOver.run(scoreGameOverAction)
//            
//            let bonusGame = SKLabelNode(text: "Bonus Game")
//            bonusGame.fontSize = 22
//            bonusGame.position = CGPoint(x: widht / 2, y: -75)
//            bonusGame.zPosition = 1
//            bonusGame.name = "bonus_game"
//            scene.addChild(bonusGame)
//            let bonusGameAction = SKAction.move(to: CGPoint(x: widht / 2, y: height / 2 - 65), duration: 1)
//            scoreGameOver.run(bonusGameAction)
            
            return
        }
    }
    
}
