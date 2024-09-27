//
//  DetailView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import SwiftUI

struct DetailView: View {
    var item: ContentItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let thumbnailData = item.thumbnailData, let image = UIImage(data: thumbnailData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal)
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

                Button(action: shareItem) {
                    HStack {
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    func openURL() {
        if let url = URL(string: item.url) {
            UIApplication.shared.open(url)
        }
    }

    func shareItem() {
        guard let url = URL(string: item.url) else { return }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
