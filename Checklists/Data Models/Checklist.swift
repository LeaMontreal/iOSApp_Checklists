//
//  Checklist.swift
//  Checklists
//
//  Created by user206341 on 10/21/21.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"    // here's an tranparent png named "No Icon"
    
    init(name: String, iconName: String = "No Icon"){
        self.name = name
        self.iconName = iconName
        
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items {
            if !item.checked {
                count += 1
            }
        }
        
        return count
    }
}
