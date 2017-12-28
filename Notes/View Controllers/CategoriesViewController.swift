//
//  CategoriesViewController.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 28..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit
import CoreData

extension Segue {
    static let addCategory = "AddCategory"
    static let category = "Category"
}

class CategoriesViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var note: Note?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        guard let managedObjectContext = note?.managedObjectContext else {
            fatalError("No Managed Object Context Found")
        }
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCategories()
    }
    
    private func fetchCategories() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Segue.addCategory:
            guard let destination = segue.destination as? AddCategoryViewController else { return }
            destination.managedObjectContext = note?.managedObjectContext
        case Segue.category:
            guard let destination = segue.destination as? CategoryViewController else { return }
            destination.category = note?.category
            
        default:
            break
        }
    }
    
    fileprivate func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        let category = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = category.name
        
        cell.nameLabel.textColor = note?.category == category ? .gray : .black
        
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("Unexpected IndexPath")
        }
        
        configure(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let category = fetchedResultsController.object(at: indexPath)
        
        note?.managedObjectContext?.delete(category)
    }
    
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = fetchedResultsController.object(at: indexPath)
        
        
        note?.category = category
        navigationController?.popViewController(animated: true)
    }
    
}

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }
}
