//
//  PlikoGameView.swift
//  Whack Pliko
//
//  Created by Anton on 13/3/24.
//

import SwiftUI
import SpriteKit

struct PlikoBonusGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var gameData: GameData
    
    @State var dropedBall = false
    @State var receivedBonusResult = false
    
    @State private var scale: CGFloat = 0
    @State private var isScaled = false
    
    var scene: SKScene {
        let scene = PlikoScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: 460)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        NavigationLink(destination: RulesView(goRules: .constant(true), fromMenu: true)) {
                            Image("rules_2")
                        }
                        
                        Spacer().frame(width: 8)
                        
                        ZStack {
                            Image("points_bg")
                            HStack {
                                Image("money")
                                Text("\(PlikoData.shared.scoreGaned)")
                                    .bold()
                                    .font(.system(size: 25))
                            }
                        }
                        
                        Spacer().frame(width: 8)
                        
                        Image("bonus_label")
                    }
                    
                    SpriteView(scene: scene)
                        .frame(height: 460)
                        .padding(4)
                    
                    Button {
                        NotificationCenter.default.post(name: Notification.Name("GET_BONUS"), object: nil)
                        dropedBall = true
                    } label: {
                        Image("get_bonus")
                    }
                    .disabled(dropedBall)
                }
                
                if receivedBonusResult {
                    Image("win_bonus")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(0.6)
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("MULTIPLY_BONUS"))) { notification in
            if let userInfo = notification.userInfo {
                if let score = userInfo["totalScore"] as? Int {
                    self.gameData.addScore(score)
                    withAnimation(.easeInOut(duration: 0.5)) {
                        receivedBonusResult = true
                        isScaled = true
                        scale = 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        presMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    PlikoBonusGameView()
}
