//
//  ShareExtensionView.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

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
                    TextField("Enter title", text: $viewModel.sharedTitle)
                        .disableAutocorrection(true)
                }
                Section(header: Text("Category").font(.headline)) {
                    Picker("Select Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
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
