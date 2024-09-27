//
//  CategorySelectionViewController.swift
//  ReadOrLookItLater
//
//  Created by Onur Uğur on 27.09.2024.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func categorySelected(_ category: String)
}

class CategorySelectionViewController: UITableViewController {
    var categories: [String] = []
    weak var delegate: CategorySelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Kategori Seçimi"
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return categories.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        delegate?.categorySelected(categories[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
