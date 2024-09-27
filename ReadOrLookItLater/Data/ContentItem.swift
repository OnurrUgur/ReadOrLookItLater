//
//  ContentItem.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.


import Foundation

public struct ContentItem: Identifiable, Codable {
    public var id: UUID
    public var title: String
    public var url: String
    public var category: String
    public var dateAdded: Date
    public var note: String?
    public var thumbnailData: Data?

    public init(id: UUID, title: String, url: String, category: String, dateAdded: Date, note: String? = nil, thumbnailData: Data? = nil) {
        self.id = id
        self.title = title
        self.url = url
        self.category = category
        self.dateAdded = dateAdded
        self.note = note
        self.thumbnailData = thumbnailData
    }
}
