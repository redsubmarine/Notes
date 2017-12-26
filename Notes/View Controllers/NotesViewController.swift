//
//  ViewController.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 26..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit
import CoreData

struct Segue {
    static let addNote = "AddNote"
}

final class NotesViewController: UIViewController {
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let note = Note(context: coreDataManager.managedObjectContext)
        
        note.title = "My Second Note"
        note.createdAt = Date()
        note.updatedAt = Date()
        
        print(note)
        
        do {
            try coreDataManager.managedObjectContext.save()
        } catch {
            print("Unable to Save Managed Object Context")
            print("\(error), \(error.localizedDescription)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Segue.addNote:
            guard let destination = segue.destination as? AddNoteViewController else { return }
            destination.managedObjectContext = coreDataManager.managedObjectContext
        default:
            break
        }
        
    }
    
}
