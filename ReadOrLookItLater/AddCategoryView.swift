//
//  AddCategoryView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var categories: [String]
    @State private var newCategory: String = ""
    let defaults = UserDefaults(suiteName: "group.com.onur.ugur.app.share")

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Yeni Kategori")) {
                    TextField("Kategori Adı", text: $newCategory)
                }

                Button(action: addCategory) {
                    Text("Ekle")
                }
            }
            .navigationTitle("Kategori Ekle")
            .navigationBarItems(trailing: Button("Kapat") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    func addCategory() {
        if !newCategory.isEmpty {
            categories.append(newCategory)
            defaults?.set(categories, forKey: "categories")
            presentationMode.wrappedValue.dismiss()
        }
    }
}
