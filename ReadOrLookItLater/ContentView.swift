//
//  ContentView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

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
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(filteredItems) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            Text(item.title)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    showingAddCategory = true
                }) {
                    Text("Kategori Ekle")
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
}
