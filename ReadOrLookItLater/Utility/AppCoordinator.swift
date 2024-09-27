// AppCoordinator.swift

import SwiftUI

enum AppCoordinatorState {
    case splashScreen
    case onboarding
    case mainContent
}

class AppCoordinator: ObservableObject {
    @Published var state: AppCoordinatorState = .splashScreen

    func proceedAfterSplash() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if hasCompletedOnboarding {
            navigate(to: .mainContent)
        } else {
            navigate(to: .onboarding)
        }
    }

    func navigate(to state: AppCoordinatorState) {
        withAnimation {
            self.state = state
        }
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        proceedAfterSplash()
    }
}
