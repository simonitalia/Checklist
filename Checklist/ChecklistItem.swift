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
    
    var text = ""
    var checked = false
        //checkmark flag
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
    
    //Method for marking items completed using textbased, visual checkmark
    func checkmarkToggle() {
        checked = !checked
    }
    
    
   //Required NSCoding initializer methods
   //Load/read initializer method
    required init(coder aDecoder: NSCoder) {
//        super.init()
        text = aDecoder.decodeObject(forKey: "text") as! String
        checked = aDecoder.decodeObject(forKey: "checked") as! Bool
    }
    
    //Save/write initializer method
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(checked, forKey: "checked")
    }

}
