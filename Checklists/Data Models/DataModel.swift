//
//  DataModel.swift
//  Checklists
//
//  Created by user206341 on 10/22/21.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    // save index of the checklist user selected
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        
        set {
            return UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        print("TAG data file path: \(getDataFilePath())")

        loadChecklist()
        registerDefaults()
        handleFirstTime()
    }
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getDataFilePath() -> URL {
        return getDocumentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // save lists to file "Checklists.plist"
    func saveChecklist() {
        // 1. create an encoder
        let encoder = PropertyListEncoder()
        
        do {
            // 2. encode
            let data = try encoder.encode(lists)
            // 3. write data
            // options: Data.WritingOptions.atomic
            try data.write(to: getDataFilePath(), options: .atomic)
        // 4. catch error
        }catch{
            // 5. deal with error
            print("Error encoding lists: \(error.localizedDescription)")
        }
    }
    
    func loadChecklist(){
        // 1. create a Data object
        if let data = try? Data(contentsOf: getDataFilePath()){
            // 2. create a PropertyListDecoder object
            let decoder = PropertyListDecoder()
            do {
                // 3. decode, put result into lists
                lists = try decoder.decode([Checklist].self, from: data)

                // 4. more operation to lists
                sortChecklists()

            }catch{
                print("Error decoding lists: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func registerDefaults() {
        // when there're different types of values, use as to tell compiler we do want Any type
//        let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any]
        // not necessory give a key value=0, if a key hasn't been mentioned, it's value is 0
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true, "NextChecklistItemID": 0] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefault = UserDefaults.standard
        let firstTime = userDefault.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefault.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists() {
        //
        lists.sort {list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    // This is a class func
    class func nextChecklistItemID() -> Int {
        let userDefault = UserDefaults.standard
        let itemID = userDefault.integer(forKey: "NextChecklistItemID")
        userDefault.set(itemID + 1, forKey: "NextChecklistItemID")
        
        // return the old itemID, a little wierd ???
        return itemID
    }
}
