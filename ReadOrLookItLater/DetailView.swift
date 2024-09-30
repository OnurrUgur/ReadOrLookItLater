// DetailView.swift
// ReadOrLookItLater
//
// Created by Onur Uğur on 27.09.2024.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

struct DetailView: View {
    var item: ContentItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let thumbnailData = item.thumbnailData {
                    #if os(iOS)
                    if let image = UIImage(data: thumbnailData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    } else {
                        defaultImageView
                    }
                    #elseif os(macOS)
                    if let image = NSImage(data: thumbnailData) {
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    } else {
                        defaultImageView
                    }
                    #endif
                } else {
                    defaultImageView
                }

                Text(item.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                if let note = item.note, !note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note")
                            .font(.headline)
                        Text(note)
                            .font(.body)
                    }
                    .padding(.horizontal)
                }

                HStack {
                    Text("Category:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(item.category)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(formattedDate(item.dateAdded))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Divider()
                    .padding(.vertical)

                Button(action: openURL) {
                    HStack {
                        Spacer()
                        Image(systemName: "safari")
                        Text("Open in Browser")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Details")
        
    }

    var defaultImageView: some View {
        Image("thumbnail_image")
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .clipped()
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal)
    }

    func openURL() {
        if let url = URL(string: item.url) {
            #if os(iOS)
            UIApplication.shared.open(url)
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
