//
//  PersistenceController.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        let appGroupID = "group.com.onur.ugur.app.share" // Kendi App Group ID'nizi buraya girin

        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            fatalError("App Group container URL bulunamadı. App Group ID'nizi ve ayarlarınızı kontrol edin.")
        }

        let storeURL = containerURL.appendingPathComponent("ReadOrLookItLater.sqlite")

        let description = NSPersistentStoreDescription(url: storeURL)
        container = NSPersistentContainer(name: "ReadOrLookItLaterModel")
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data yüklenemedi: \(error)")
            }
        }
    }
}

