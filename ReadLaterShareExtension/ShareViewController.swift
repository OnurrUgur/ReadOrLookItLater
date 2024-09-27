//
//  ShareViewController.swift
//  ReadLaterShareExtension
//
//  Created by Onur Uğur on 27.09.2024.
//

// ShareViewController.swift
// ReadLaterShareExtension

import UIKit
import SwiftUI
import MobileCoreServices

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SwiftUI view and set the context
        let contentView = ShareExtensionView(extensionContext: extensionContext)
        let hostingController = UIHostingController(rootView: contentView)

        // Add the hosting controller as a child view controller
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        // Constrain the hosting controller's view to the parent
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}
