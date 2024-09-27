//
//  ContentView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataManager = DataManager.shared
    let defaults = UserDefaults(suiteName: "group.com.onur.ugur.app.share")
    @State private var categories: [String] = []

    @State private var selectedCategory: String = "Tümü"
    @State private var showingAddCategory = false

    var body: some View {
        NavigationView {
            VStack {
                Picker("Kategori", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(filteredItems) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            HStack(alignment: .top, spacing: 10) {
                                if let thumbnailData = item.thumbnailData, let image = UIImage(data: thumbnailData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                        .clipped()
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                    if let note = item.note, !note.isEmpty {
                                        Text(note)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    Text("Eklendi: \(formattedDate(item.dateAdded))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    showingAddCategory = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Kategori Ekle")
                    }
                    .font(.headline)
                }
                .padding()
                .sheet(isPresented: $showingAddCategory) {
                    AddCategoryView(categories: $categories)
                }
            }
            .navigationTitle("Kaydedilen İçerikler")
            .onAppear {
                loadCategories()
            }
        }
    }

    private var filteredItems: [ContentItem] {
        if selectedCategory == "Tümü" {
            return dataManager.contentItems
        } else {
            return dataManager.contentItems.filter {
                $0.category == selectedCategory
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        dataManager.deleteItems(at: offsets)
    }

    private func loadCategories() {
        if let savedCategories = defaults?.stringArray(forKey: "categories") {
            categories = savedCategories
        } else {
            categories = ["Tümü", "Okunacaklar", "İzlenecekler", "Favoriler"]
            defaults?.set(categories, forKey: "categories")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
