//
//  ContentItem.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//


import Foundation

struct ContentItem: Identifiable, Codable {
    var id: UUID
    var title: String
    var url: String
    var category: String
    var dateAdded: Date
}
