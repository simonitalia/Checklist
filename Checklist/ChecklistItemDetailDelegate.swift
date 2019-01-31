//
//  ChecklistItemDelegate.swift
//  Checklists
//
//  Created by Simon Italia on 1/31/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import Foundation

//Note! Appending protocol with "class"means this will only work on classes. Running on struct or enum will generate compiler error
protocol ChecklistItemDetailDelegate: class {
    
    func checklistItemDetailDidCancel(_ controller: DetailViewController)
        //When cancelling item add or edit
    
    func checklistItemDetailDidFinishAdding(_ controller: DetailViewController, didFinishAdding item: ChecklistItem)
        // When adding an item
    
    func checklistItemDetailDidFinishEditing(_ controller: DetailViewController, didFinishEditing item: ChecklistItem)
        //When editing an item
}
