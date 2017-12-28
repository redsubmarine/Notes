//
//  NoteViewController.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 28..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Note"
        
        setupView()
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
}
