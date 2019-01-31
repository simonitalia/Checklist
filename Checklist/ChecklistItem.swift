//
//  Checklistitem.swift
//  Checklists
//
//  Created by Simon Italia on 5/15/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    
    var text = ""
    var checked = false
        //checkmark flag
    
    func checkmarkToggle() {
        checked = !checked
    }
}
