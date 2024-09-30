// OnboardingView.swift
// ReadOrLookItLater
//
// Created by Onur Uğur on 27.09.2024.
//

import SwiftUI
import AVKit

struct OnboardingView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        TabView {
            onboardingPageWithVideo(videoName: "sharingExtensionDemo", title: "Welcome!", description: "Save your content and access it easily later. Select our app from the share menu to save content.")
            onboardingFinalPage
        }
        .tabViewStyle(PageTabViewStyle())
        .ignoresSafeArea()
    }

    func onboardingPageWithVideo(videoName: String, title: String, description: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: "mp4")!))
                .frame(height: 600)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("OnboardingGradientStart"), Color("OnboardingGradientEnd")]), startPoint: .top, endPoint: .bottom)
        )
        .foregroundColor(.white)
    }

    func onboardingPage(imageName: String, title: String, description: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("OnboardingGradientStart"), Color("OnboardingGradientEnd")]), startPoint: .top, endPoint: .bottom)
        )
        .foregroundColor(.white)
    }

    var onboardingFinalPage: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("onboarding3")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            Text("Categories")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text("Organize your content into categories for better structure.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                coordinator.completeOnboarding()
            }) {
                Text("Get Started")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(Color("OnboardingButtonText"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("OnboardingGradientStart"), Color("OnboardingGradientEnd")]), startPoint: .top, endPoint: .bottom)
        )
        .foregroundColor(.white)
    }
}
