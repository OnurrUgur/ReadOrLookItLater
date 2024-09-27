//
//  ShareExtensionViewModel.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

// ShareExtensionViewModel.swift
// ReadLaterShareExtension

import SwiftUI
import MobileCoreServices

class ShareExtensionViewModel: ObservableObject {
    @Published var sharedTitle: String = ""
    @Published var sharedURL: String = ""
    @Published var selectedCategory: String = ""
    @Published var categories: [String] = []

    private let appGroupID = "group.com.onur.ugur.app.share"
    private let fileName = "ContentItems.json"
    private let defaults = UserDefaults(suiteName: "group.com.onur.ugur.app.share")
    private var extensionContext: NSExtensionContext?

    init(extensionContext: NSExtensionContext?) {
        self.extensionContext = extensionContext
    }

    var isContentValid: Bool {
        !sharedTitle.isEmpty && !sharedURL.isEmpty
    }

    func loadCategories() {
        if let savedCategories = defaults?.stringArray(forKey: "categories") {
            categories = savedCategories.filter { $0 != "Tümü" }
        } else {
            categories = ["Okunacaklar", "İzlenecekler", "Favoriler"]
        }
        selectedCategory = categories.first ?? "Okunacaklar"
    }

    func handleIncomingContent() {
        guard let extensionContext = extensionContext else { return }
        if let item = extensionContext.inputItems.first as? NSExtensionItem {
            if let attachments = item.attachments {
                for attachment in attachments {
                    if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                        attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (data, error) in
                            if let url = data as? URL {
                                DispatchQueue.main.async {
                                    self.sharedURL = url.absoluteString
                                    self.sharedTitle = url.absoluteString
                                }
                            }
                        }
                        return
                    } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                        attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) { (data, error) in
                            if let text = data as? String {
                                DispatchQueue.main.async {
                                    self.sharedURL = ""
                                    self.sharedTitle = text
                                }
                            }
                        }
                        return
                    }
                }
            }
        }
    }

    func cancel() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    func post() {
        saveItem()
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    private func saveItem() {
        let newItem = ContentItem(
            id: UUID(),
            title: self.sharedTitle,
            url: self.sharedURL,
            category: self.selectedCategory,
            dateAdded: Date()
        )

        guard let containerURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
        else {
            print("App Group container URL not found.")
            return
        }

        let fileURL = containerURL.appendingPathComponent(fileName)
        var existingItems: [ContentItem] = []

        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                existingItems = try decoder.decode([ContentItem].self, from: data)
            }
        } catch {
            print("Failed to load existing items: \(error)")
        }

        existingItems.insert(newItem, at: 0)

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(existingItems)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save items: \(error)")
        }
    }
}
