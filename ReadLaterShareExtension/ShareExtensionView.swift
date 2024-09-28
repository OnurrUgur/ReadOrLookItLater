//
//  ShareExtensionView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.


import SwiftUI
import MobileCoreServices

struct ShareExtensionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: ShareExtensionViewModel

    init(extensionContext: NSExtensionContext?) {
        _viewModel = StateObject(wrappedValue: ShareExtensionViewModel(extensionContext: extensionContext))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title").font(.headline)) {
                    HStack {
                        Image(systemName: "textformat")
                            .foregroundColor(.gray)
                        TextField("Enter title", text: $viewModel.sharedTitle)
                            .disableAutocorrection(true)
                    }
                }

                Section(header: Text("Category").font(.headline)) {
                    HStack {
                        Image(systemName: "folder")
                            .foregroundColor(.gray)
                        Picker("Select Category", selection: $viewModel.selectedCategory) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }

                Section(header: Text("Note").font(.headline)) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                        TextField("Add a note", text: $viewModel.note)
                            .disableAutocorrection(false)
                    }
                }

            }
            .navigationBarTitle("Add to ReadLater", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel", action: viewModel.cancel),
                trailing: Button("Save", action: viewModel.post)
                    .disabled(!viewModel.isContentValid)
            )
        }
        .onAppear {
            viewModel.loadCategories()
            viewModel.handleIncomingContent()
        }
    }
}
