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
        VStack(alignment: .leading, spacing: 20) {
            Text(item.title)
                .font(.title)
                .padding(.top)

            Text("Kategori: \(item.category)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(action: openURL) {
                Text("Kaynağa Git")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Detaylar")
    }

    func openURL() {
        if let url = URL(string: item.url) {
            UIApplication.shared.open(url)
        }
    }
}
