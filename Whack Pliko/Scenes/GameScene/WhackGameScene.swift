//
//  WhackGameScene.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import Foundation
import SpriteKit

class WhackGameScene: SKScene {
    
    var gameVieModel: WhackGameViewModel = WhackGameViewModel()
    
    override func didMove(to view: SKView) {
        gameVieModel.createScene(self)
        gameVieModel.createEnemy(with: 1, in: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameVieModel.hitBall(touches, in: self)
    }
    
}
