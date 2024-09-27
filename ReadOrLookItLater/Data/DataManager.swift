// DataManager.swift
// ReadOrLookItLater

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    let appGroupID = "group.com.onur.ugur.app.share" // Your App Group ID
    let fileName = "ContentItems.json"

    @Published var contentItems: [ContentItem] = []

    private init() {
        loadItems()
    }

    private var fileURL: URL {
        guard let containerURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
        else {
            fatalError("App Group container URL not found.")
        }
        return containerURL.appendingPathComponent(fileName)
    }

    func loadItems() {
        DispatchQueue.global(qos: .background).async {
            let url = self.fileURL
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let items = try decoder.decode([ContentItem].self, from: data)
                DispatchQueue.main.async {
                    self.contentItems = items
                    print("Items loaded successfully. Total items: \(self.contentItems.count)")
                }
            } catch {
                print("Failed to load items: \(error)")
                DispatchQueue.main.async {
                    self.contentItems = []
                    self.saveItems()
                }
            }
        }
    }

    func saveItems() {
        DispatchQueue.global(qos: .background).async {
            let url = self.fileURL
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                let data = try encoder.encode(self.contentItems)
                try data.write(to: url)
                print("Items saved successfully. Total items: \(self.contentItems.count)")
            } catch {
                print("Failed to save items: \(error)")
            }
        }
    }

    func addItem(_ item: ContentItem) {
        DispatchQueue.main.async {
            self.contentItems.insert(item, at: 0)
            self.saveItems()
            print("Item added. Total items: \(self.contentItems.count)")
        }
    }

    func deleteItems(at offsets: IndexSet) {
        DispatchQueue.main.async {
            for index in offsets.sorted(by: >) {
                self.contentItems.remove(at: index)
            }
            self.saveItems()
            print("Items deleted. Total items: \(self.contentItems.count)")
        }
    }
}
