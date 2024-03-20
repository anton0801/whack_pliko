//
//  PlikoSceneView.swift
//  Whack Pliko
//
//  Created by Anton on 13/3/24.
//

import Foundation
import SpriteKit

class PlikoScene: SKScene, SKPhysicsContactDelegate {
    
    var gameViewModel: GamePlikoViewModel!
    
    override func didMove(to view: SKView) {
        view.allowsTransparency = true
        self.backgroundColor = .clear
        view.isOpaque = true
        view.backgroundColor = SKColor.clear.withAlphaComponent(0.0)
    
        gameViewModel = GamePlikoViewModel(scoreGaned: PlikoData.shared.scoreGaned)
        gameViewModel.setPhysicBody(to: self)
        gameViewModel.setContactDelegate(to: self, delegate: self)
        gameViewModel.setUpGame(to: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("GET_BONUS"), object: nil)
    }
    
    // Method to handle the notification
   @objc func handleNotification(_ notification: Notification) {
       gameViewModel.dropBall(to: self)
   }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        gameViewModel.collissionBetweenObjects(contact, in: self)
    }
    
}
