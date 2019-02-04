//
//  Checklistitem.swift
//  Checklists
//
//  Created by Simon Italia on 5/15/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
       //NSObject, NSCoding used for saving / loading data from disk
    
    var text: String
    var checked: Bool
        //checkmark flag
    var checkedLabel: String
    
    init(text: String, checked: Bool, checkedLabel: String) {
        self.text = text
        self.checked = checked
        self.checkedLabel = checkedLabel
    }
    
    //Method for marking items completed using textbased, visual checkmark
    func checkmarkToggle() {
        checked = !checked
        
        if checked {
            checkedLabel = "√"
            
        } else {
            checkedLabel = ""
        }
    }
    
   //Required NSCoding initializer methods
   //Initializer method, to load objects of this class
    required init(coder aDecoder: NSCoder) {
//        super.init()
        text = aDecoder.decodeObject(forKey: "text") as! String
        checkedLabel = aDecoder.decodeObject(forKey: "checkedLabel") as! String
        checked = aDecoder.decodeBool(forKey: "checked") 

    }
    
    //Save/write objects of this class method
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(checked, forKey: "checked")
        aCoder.encode(checkedLabel, forKey: "checkedLabel")
    }
}
