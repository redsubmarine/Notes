//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 27..
//  Copyright © 2017년 red. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    static let reuseIdentifier = "NoteTableViewCell"
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    
}
