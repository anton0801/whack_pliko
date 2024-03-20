//
//  RulesView.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import SwiftUI

struct RulesView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @Binding var goRules: Bool
    var fromMenu: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if fromMenu {
                        presMode.wrappedValue.dismiss()
                    } else {
                        goRules = false
                    }
                } label: {
                    Image("back_btn")
                }
                Spacer()
                Image("rules_btn")
                Spacer()
            }
            .padding([.leading, .trailing], 24)
            Image("rules_text")
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
    RulesView(goRules: .constant(false), fromMenu: false)
}
