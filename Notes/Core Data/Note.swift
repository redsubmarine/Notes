//
//  Note.swift
//  Notes
//
//  Created by 양원석 on 2017. 12. 27..
//  Copyright © 2017년 red. All rights reserved.
//

import Foundation

extension Note {
    var updatedAtAsDate: Date {
        return updatedAt ?? Date()
    }
}
