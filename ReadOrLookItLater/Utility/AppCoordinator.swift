//
// AppCoordinator.swift


import SwiftUI

enum AppCoordinatorState {
    case splashScreen
    case onboarding
    case mainContent
}

class AppCoordinator: ObservableObject {
    @Published var state: AppCoordinatorState = .splashScreen

    init() {
        checkIfOnboardingCompleted()
    }

    func checkIfOnboardingCompleted() {
        let hasCompletedOnboarding = UserDefaults.standard
            .bool(forKey: "hasCompletedOnboarding")
        if hasCompletedOnboarding {
            state = .mainContent
        } else {
            state = .onboarding
        }
    }

    func navigate(to state: AppCoordinatorState) {
        withAnimation {
            self.state = state
        }
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        navigate(to: .mainContent)
    }
}
