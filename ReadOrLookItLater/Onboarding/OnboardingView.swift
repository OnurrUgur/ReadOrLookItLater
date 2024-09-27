//
//  OnboardingView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        TabView {
            VStack {
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Hoş geldiniz!")
                    .font(.largeTitle)
                    .padding()
                Text("Ekranınızdaki herhangi bir içeriği kaydedin ve daha sonra kolayca erişin.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            VStack {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Paylaşım Uzantısı")
                    .font(.largeTitle)
                    .padding()
                Text("Paylaş menüsünden uygulamamızı seçerek içerikleri kaydedebilirsiniz.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            VStack {
                Image(systemName: "folder.badge.plus")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Kategoriler")
                    .font(.largeTitle)
                    .padding()
                Text("İçeriklerinizi kategorilere ayırarak düzenli tutun.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            VStack {
                Button(action: {
                    coordinator.completeOnboarding()
                }) {
                    Text("Başla")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
