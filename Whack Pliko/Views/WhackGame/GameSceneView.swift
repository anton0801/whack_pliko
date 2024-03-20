//
//  GameSceneView.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var gameData: GameData
    
    @State var showGameOver = false
    @State var bonusGameGo = false
    @State var showRules = false
    
    @State var gameId: String? = nil
    
    var scene: SKScene {
        let scene = WhackGameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        if bonusGameGo {
            PlikoBonusGameView()
                .environmentObject(gameData)
        } else if showRules {
            RulesView(goRules: $showRules, fromMenu: false)
        } else {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_OVER"))) { notification in
                    if let data = notification.userInfo?["data"] as? Int {
                        if let gameId = notification.userInfo?["gameId"] as? String {
                            if gameId != self.gameId {
                                showGameOver = true
                                PlikoData.shared.scoreGaned = data
                                self.gameId = gameId
                            }
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CLOSE_GAME"))) { _ in
                    presMode.wrappedValue.dismiss()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RULES_GAME"))) { _ in
                    showRules = true
                }
                .alert(isPresented: $showGameOver) {
                    Alert(
                        title: Text("Game over"),
                        message: Text("The game is over, but you have a chance to play in the bonus game, if you don't win anything you won't lose anything, and if you win, these points will be added to your main balance."),
                        primaryButton: .destructive(Text("Play Bonus")) {
                            bonusGameGo = true
                        },
                        secondaryButton: .cancel() {
                            gameData.addScore(PlikoData.shared.scoreGaned)
                            PlikoData.shared.scoreGaned = 0
                        }
                    )
                }
        }
    }
}

#Preview {
    GameSceneView()
        .environmentObject(GameData())
}
