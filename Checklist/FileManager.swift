//
//  FileManager.swift
//  Checklists
//
//  Created by Simon Italia on 5/21/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import Foundation

public extension FileManager {
    static var documentDirectoryURL: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    
    
}
