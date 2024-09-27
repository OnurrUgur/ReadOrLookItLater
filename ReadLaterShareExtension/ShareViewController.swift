//
//  ShareViewController.swift
//  ReadLaterShareExtension
//
//  Created by Onur Uğur on 27.09.2024.
//

// ShareViewController.swift
// ReadLaterShareExtension

import UIKit
import Social
import MobileCoreServices
import Foundation

class ShareViewController: SLComposeServiceViewController {
    var sharedURL: String = ""
    var sharedTitle: String = ""
    var selectedCategory: String = "Okunacaklar"
    var categories: [String] = []
    let appGroupID = "group.com.onur.ugur.app.share"
    let fileName = "ContentItems.json"
    let defaults = UserDefaults(suiteName: "group.com.onur.ugur.app.share")

    override func isContentValid() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    override func didSelectPost() {
        if let item = self.extensionContext?.inputItems.first as? NSExtensionItem {
            if let attachments = item.attachments {
                for attachment in attachments {
                    if attachment.hasItemConformingToTypeIdentifier(
                        kUTTypeURL as String
                    ) {
                        attachment.loadItem(
                            forTypeIdentifier: kUTTypeURL as String,
                            options: nil
                        ) { (data, error) in
                            if let url = data as? URL {
                                self.sharedURL = url.absoluteString
                                self.sharedTitle = self.contentText.isEmpty
                                    ? url.absoluteString
                                    : self.contentText
                                self.saveItem()
                            }
                            self.extensionContext!.completeRequest(
                                returningItems: [], completionHandler: nil
                            )
                        }
                    }
                }
            }
        }
    }

    override func configurationItems() -> [Any]! {
        let item = SLComposeSheetConfigurationItem()!
        item.title = "Kategori"
        item.value = selectedCategory
        item.tapHandler = showCategorySelection
        return [item]
    }

    func showCategorySelection() {
        let vc = CategorySelectionViewController()
        vc.categories = categories
        vc.delegate = self
        pushConfigurationViewController(vc)
    }

    func saveItem() {
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

    func loadCategories() {
        if let savedCategories = defaults?.stringArray(forKey: "categories") {
            categories = savedCategories.filter { $0 != "Tümü" }
        } else {
            categories = ["Okunacaklar", "İzlenecekler", "Favoriler"]
        }
    }
}

extension ShareViewController: CategorySelectionDelegate {
    func categorySelected(_ category: String) {
        selectedCategory = category
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}
