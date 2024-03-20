//
//  MenuView.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import SwiftUI

struct MenuView: View {
    
    @StateObject var gameData: GameData = GameData()
    
    @State var goToGame = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("points_bg")
                    HStack {
                        Image("money")
                        Text("\(gameData.score)")
                            .bold()
                            .font(.system(size: 25))
                    }
                }
                Spacer()
                NavigationLink(destination: GameSceneView()
                    .environmentObject(gameData)
                    .navigationBarBackButtonHidden(true), isActive: $goToGame) {
                    EmptyView()
                }
                Button {
                    goToGame = true
                } label: {
                    Image("play_btn")
                }
                HStack {
                    NavigationLink(destination: RulesView(goRules: .constant(true), fromMenu: true)
                        .navigationBarBackButtonHidden(true)) {
                        Image("rules_btn")
                    }
                    NavigationLink(destination: ProgressGameView()
                        .environmentObject(gameData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("progress_btn")
                    }
                }
                NavigationLink(destination: PrivacyPolicyView()
                    .navigationBarBackButtonHidden(true)) {
                    Image("privacy_policy_btn")
                }
                
                Spacer()
            }
            .background(
                Image("background")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                    .opacity(0.8)
            )
            .onAppear {
                AppDelegate.orientationLock = .portrait
            }
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MenuView()
}
