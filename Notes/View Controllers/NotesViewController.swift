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
    
    private var hasNotes: Bool {
        return notes?.count ?? 0 > 0
    }
    
    private var notes: [Note]? {
        didSet {
            updateView()
        }
    }
    
    private lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        fetchNotes()
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
    
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        coreDataManager.managedObjectContext.performAndWait({
            do {
                let notes = try fetchRequest.execute()
                self.notes = notes
                self.tableView.reloadData()
            } catch {
                print("Unable to Execute Fetch Request")
                print("\(error), \(error.localizedDescription)")
            }
        })
    }
    
    func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
    
}

extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hasNotes ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let note = notes?[indexPath.row] else {
            fatalError("Unexpected IndexPath")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unexpected IndexPath")
        }
        
        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
        
        return cell
    }
    
}
