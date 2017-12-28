//
//  AddCategoryViewController.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 28..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category"
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(with: "Name Missing", and: "Category doesn't have a name.")
            return
        }
        
        let category = Category(context: managedObjectContext)
        category.name = name
        
        navigationController?.popViewController(animated: true)
    }
    
}
