//
//  NoteViewController.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 28..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit
import CoreData

extension Segue {
    static let categories = "Categories"
}

final class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Note"
        
        setupView()
        
        setupNotificationHandling()
        updateCategoryLabel()
    }
    
    private func setupView() {
        titleTextField.text = note?.title
        contentsTextView.text = note?.contents
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let title = titleTextField.text, !title.isEmpty {
            note?.title = title
        }
        
        note?.updatedAt = Date()
        note?.contents = contentsTextView.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case Segue.categories:
            guard let destination = segue.destination as? CategoriesViewController else {
                return
            }
            destination.note = note
        default:
            break
        }
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(managedObejctContextObjectsDidChange(_:)), name: .NSManagedObjectContextObjectsDidChange, object: note?.managedObjectContext)
    }
    
    @objc private func managedObejctContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else {
            return
        }
        
        if updates.filter({ $0 == note }).count > 0 {
            updateCategoryLabel()
        }
    }
    
    private func updateCategoryLabel() {
        categoryLabel.text = note?.category?.name ?? "No Category"
    }
}
