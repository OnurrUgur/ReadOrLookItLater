//  ShareExtensionViewModel.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import SwiftUI
import MobileCoreServices
import LinkPresentation
import UniformTypeIdentifiers

class ShareExtensionViewModel: ObservableObject {
    @Published var sharedTitle: String = ""
    @Published var sharedURL: String = ""
    @Published var selectedCategory: String = ""
    @Published var categories: [String] = []
    @Published var note: String = ""
    @Published var thumbnailImage: UIImage?

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
                    // Log all registered type identifiers
                    for typeIdentifier in attachment.registeredTypeIdentifiers {
                        print("Attachment type: \(typeIdentifier)")
                    }

                    // Handle kUTTypeURL (public.url)
                    if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                        print("Found kUTTypeURL")
                        attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (data, error) in
                            if let url = data as? URL {
                                print("Loaded URL: \(url.absoluteString)")
                                DispatchQueue.main.async {
                                    self.sharedURL = url.absoluteString
                                    self.sharedTitle = url.absoluteString
                                    self.loadThumbnail(from: url)
                                }
                            } else {
                                print("Failed to load URL")
                            }
                        }
                        return
                    }

                    // Handle kUTTypeText (public.text)
                    else if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                        print("Found kUTTypeText")
                        attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) { (data, error) in
                            if let text = data as? String {
                                print("Loaded text: \(text)")
                                DispatchQueue.main.async {
                                    self.sharedURL = ""
                                    self.sharedTitle = text
                                }
                            } else {
                                print("Failed to load text")
                            }
                        }
                        return
                    }

                    // Handle kUTTypePropertyList (public.property-list)
                    else if attachment.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                        print("Found kUTTypePropertyList")
                        attachment.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) { (item, error) in
                            if let dictionary = item as? NSDictionary {
                                print("Loaded dictionary: \(dictionary)")
                                // Extract the URL from the property list
                                if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                                   let urlString = results["URL"] as? String,
                                   let url = URL(string: urlString) {
                                    print("Extracted URL from property list: \(url.absoluteString)")
                                    DispatchQueue.main.async {
                                        self.sharedURL = url.absoluteString
                                        self.sharedTitle = url.absoluteString
                                        self.loadThumbnail(from: url)
                                    }
                                } else {
                                    print("Failed to extract URL from property list")
                                }
                            } else {
                                print("Failed to load property list")
                            }
                        }
                        return
                    }

                    // Handle public.plain-text
                    else if attachment.hasItemConformingToTypeIdentifier("public.plain-text") {
                        print("Found public.plain-text")
                        attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { (data, error) in
                            if let text = data as? String,
                               let url = URL(string: text) {
                                print("Loaded text as URL: \(url.absoluteString)")
                                DispatchQueue.main.async {
                                    self.sharedURL = url.absoluteString
                                    self.sharedTitle = url.absoluteString
                                    self.loadThumbnail(from: url)
                                }
                            } else {
                                print("Failed to load text as URL")
                            }
                        }
                        return
                    }

                    // Attempt to extract URL from attributedContentText
                    else if let attributedContentText = item.attributedContentText {
                        let text = attributedContentText.string
                        print("Found attributedContentText: \(text)")
                        if let url = URL(string: text) {
                            print("Extracted URL from attributedContentText: \(url.absoluteString)")
                            DispatchQueue.main.async {
                                self.sharedURL = url.absoluteString
                                self.sharedTitle = url.absoluteString
                                self.loadThumbnail(from: url)
                            }
                        } else {
                            print("Failed to extract URL from attributedContentText")
                            // Handle as plain text if not a valid URL
                            DispatchQueue.main.async {
                                self.sharedURL = ""
                                self.sharedTitle = text
                            }
                        }
                        return
                    }

                    else {
                        print("No matching type found. Attempting to handle as text.")
                        // Fallback to loading as text
                        attachment.loadItem(forTypeIdentifier: String(kUTTypeText), options: nil) { (data, error) in
                            if let text = data as? String {
                                print("Loaded text: \(text)")
                                DispatchQueue.main.async {
                                    self.sharedURL = ""
                                    self.sharedTitle = text
                                }
                            } else {
                                print("Failed to load item as text")
                            }
                        }
                    }
                }
            } else {
                print("No attachments found in NSExtensionItem")
            }
        } else {
            print("No input items found in extension context")
        }
    }

    
    func loadThumbnail(from url: URL) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { [weak self] metadata, error in
            if let error = error {
                print("Failed to fetch metadata: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.thumbnailImage = nil // Burada nil olarak ayarlıyoruz
                }
                return
            }

            if let imageProvider = metadata?.imageProvider {
                imageProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.thumbnailImage = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.thumbnailImage = nil // Burada da nil
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.thumbnailImage = nil // Burada da nil
                }
            }
        }
    }


    func cancel() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    func post() {
        // Convert the thumbnail image to data
        var thumbnailData: Data? = nil
        if let image = thumbnailImage {
            thumbnailData = image.jpegData(compressionQuality: 0.8)
        }

        // Create the ContentItem
        let newItem = ContentItem(
            id: UUID(),
            title: self.sharedTitle,
            url: self.sharedURL,
            category: self.selectedCategory,
            dateAdded: Date(),
            note: self.note,
            thumbnailData: thumbnailData
        )

        // Save the item
        saveItem(newItem)

        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    private func saveItem(_ newItem: ContentItem) {
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

