//
//  SplashScreenView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import SwiftUI

struct SplashScreenView: View {
    
    @ObservedObject var coordinator: AppCoordinator
    
    @State private var scale = CGSize(width: 0.8, height: 0.8)
    @State private var imageOpacity = 1.0
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ZStack {
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .opacity(imageOpacity)
                    .frame(width: 100, height: 100)
                    .offset(x: 1)
            }
            .scaleEffect(scale)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                scale = CGSize(width: 1.8, height: 1.8)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeIn(duration: 0.35)) {
                    scale = CGSize(width: 50, height: 50)
                    opacity = 0.0
                    // UserDefaults kontrolü ile duruma göre yönlendirme yapılıyor
                    coordinator.checkIfOnboardingCompleted()
                }
            }
        }
    }
}

