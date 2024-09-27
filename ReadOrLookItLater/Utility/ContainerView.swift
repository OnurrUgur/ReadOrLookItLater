//
//  ContainerView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import SwiftUI

struct ContainerView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        switch coordinator.state {
        case .splashScreen:
            SplashScreenView(coordinator: coordinator)
        case .onboarding:
            OnboardingView(coordinator: coordinator)
        case .mainContent:
            ContentView()
        }
    }
}
