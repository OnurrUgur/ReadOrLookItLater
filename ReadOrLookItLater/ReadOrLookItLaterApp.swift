//
//  ReadOrLookItLaterApp.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import SwiftUI

@main
struct ReadOrLookItLaterApp: App {
    @StateObject private var coordinator = AppCoordinator()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
