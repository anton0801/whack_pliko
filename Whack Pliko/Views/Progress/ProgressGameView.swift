//
//  ProgressGameView.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import SwiftUI

struct ProgressGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var gameData: GameData
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("back_btn")
                }
                Spacer()
                Image("progress_btn")
                Spacer()
            }
            .padding([.leading, .trailing], 24)
            
            VStack {
                HStack {
                    VStack {
                        if gameData.progressItems.contains("progress_1") {
                            Image("progress_1_active")
                        } else {
                            Image("progress_1")
                        }
                        Text("GOLDEN PLAYER")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.top)
                        Text("Win 500 points")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.top, 1)
                        
                    }
                    VStack {
                        if gameData.progressItems.contains("progress_2") {
                            Image("progress_2_active")
                        } else {
                            Image("progress_2")
                                .foregroundColor(.gray)
                        }
                        Text("Professional")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.top)
                        Text("Win 1500 points")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.top, 1)
                        
                    }
                }
                .padding(.top)
                
                VStack {
                    if gameData.progressItems.contains("progress_3") {
                        Image("progress_3_active")
                    } else {
                        Image("progress_3")
                            .foregroundColor(.gray)
                    }
                    Text("the worker")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.top)
                    Text("Win 10,000 points")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.top, 1)
                }
                .padding(.bottom)
            }
            .padding()
            .background(
                Image("progress_items_bg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width)
            )
        }
        .preferredColorScheme(.dark)
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
}

#Preview {
    ProgressGameView()
        .environmentObject(GameData())
}
