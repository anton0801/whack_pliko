//
//  PrivacyPolicyView.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    
    @Environment(\.presentationMode) var presMode
    
    let url = "https://www.freeprivacypolicy.com/live/85199f00-f1a8-4dae-9454-01291aa4944b"
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("back_btn")
                }
                Spacer()
                Image("privacy_policy_btn")
                Spacer()
            }
            .padding([.leading, .trailing])
            
            PrivacyView(url: URL(string: self.url)!)
        }
        .preferredColorScheme(.dark)
        .background(
            Image("background")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                .opacity(0.8)
        )
    }
}

#Preview {
    PrivacyPolicyView()
}

struct PrivacyView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
}
