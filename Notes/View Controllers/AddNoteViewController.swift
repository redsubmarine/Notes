//
//  AddNoteViewController.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 27..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Your note doesn't have a title.")
            return
        }
        
        let note = Note(context: managedObjectContext)
        
        note.createdAt = Date()
        note.updatedAt = Date()
        note.title = title
        note.contents = contentsTextView.text
        
        navigationController?.popViewController(animated: true)
    }
    
}
