//
//  ViewController.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 26..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
            
            let note = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
            note.setValue("My First Note", forKey: "title")
            note.setValue(Date(), forKey: "createdAt")
            note.setValue(Date(), forKey: "updatedAt")
            print(note)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
