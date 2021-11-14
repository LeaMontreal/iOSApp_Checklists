//
//  ViewController.swift
//  Checklists
//
//  Created by user206341 on 10/18/21.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    // MARK: - Navigation
    // before segue show, prepare() is called
    // sender: the object that trigger the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("TAG ChecklistViewController prepare()")
        
        // 1.check if it's the right segue
        if segue.identifier == "AddItem"{
            // 2.cast destination to ItemDetailViewController
            let controller = segue.destination as! ItemDetailViewController
            // 3.tell ItemDetailViewController that self(ChecklistViewController) is the delegate
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                // transmit data to ItemDetailViewController
                controller.itemToEdit = checklist.items[indexPath.row]
                controller.indexItemToEdit = indexPath.row
            }
        }
    }
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
//        saveChecklistItems()
        
        navigationController?.popViewController(animated: true)
    }

    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem, _ index:Int) {
        // this function is not valid anymore ??? -- it's valid after change ChecklistItem extended from NSObject
//        if let index = checklist.items.firstIndex(where: item){
//
//        }
//        if let index = checklist.items.firstIndex(of: item)

        let rowIndex = index
            print("TAG didFinishEditing() index: \(rowIndex) item.text: \(item.text)")

            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, at: indexPath)
            }
        
        navigationController?.popViewController(animated: true)
        
    }

    var checklist :Checklist!
    // move to class Checklist
//    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.prefersLargeTitles = true
        // diable large title
        navigationItem.largeTitleDisplayMode = .never
        
        title = checklist.name
        
//        let row0 = ChecklistItem()
//        row0.text = "Walk the dog"
//        row0.checked = true
//        checklist.items.append(row0)
//
//        let row1 = ChecklistItem()
//        row1.text = "Brush my teeth"
//        checklist.items.append(row1)
//
//        let row2 = ChecklistItem()
//        row2.text = "Learn development"
//        row2.checked = true
//        checklist.items.append(row2)
//
//        let row3 = ChecklistItem()
//        row3.text = "Soccer"
//        checklist.items.append(row3)
//
//        let row4 = ChecklistItem()
//        row4.text = "Eat ice cream"
//        row4.checked = true
//        checklist.items.append(row4)
        
//        loadChecklistItems()
        
//        print("Documents folder is \(getDocumentDirectory())")
//        print("Data file path is \(getDataFilePath())")
        
        
        
    }

    // MARK: - Table view Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        configureText(for: cell, at: indexPath)
        configureCheckmark(for:cell, at:indexPath)

        return cell
    }
    
    func configureText(for cell: UITableViewCell, at indexPath: IndexPath){
        let label = cell.viewWithTag(1000) as! UILabel
//        label.text = checklist.items[indexPath.row].text

        // temporary test only, show itemID
        label.text = "\(checklist.items[indexPath.row].itemID): " + checklist.items[indexPath.row].text
    }
    
    func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath){
        // use cell's accessory for showing the check mark
//        if(checklist.items[indexPath.row].checked == true){
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        // use Label (tag: 1001) for showing the check mark
        let checkMark = cell.viewWithTag(1001) as! UILabel
        if(checklist.items[indexPath.row].checked == true){
            checkMark.text = "√"
//            checkMark.text = "✅"
        }else{
            checkMark.text = ""
        }

    }
    
    // MARK: - Table View Delegate
    // recall func for select a item from tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.cellForRow(at: indexPath)
        
        // TODO: different, how to get rid of question mark
//        if cell != nil{
//            if(cell?.accessoryType == UITableViewCell.AccessoryType.none){
//                cell?.accessoryType = .checkmark
//            }else{
//                cell?.accessoryType = .none
//            }
//        }
        
        if let cell = tableView.cellForRow(at: indexPath){
            checklist.items[indexPath.row].checked.toggle()
            configureCheckmark(for: cell, at: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // recall func for delete a item from tableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - Actions
    @IBAction func addItem(){
        // save the index before add a new row into items
        let newItemIndex = checklist.items.count
        
        // update data
        let row = ChecklistItem()
        row.text = "I'm a new item"
        checklist.items.append(row)
        
        // update tableView
        let indexPath = IndexPath(row: newItemIndex, section: 0)
        // put indexPath into Array indexPaths
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    /*
     move to data model file
     func getDocumentDirectory() -> URL{
         // TODO: read more
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
     
     func getDataFilePath() -> URL {
         return getDocumentDirectory().appendingPathComponent("Checklists.plist")
     }
     
     func saveChecklistItems() {
         // 1. create an encoder
         let encoder = PropertyListEncoder()
         
         do {
             // 2. encode
             let data = try encoder.encode(checklist.items)
             // 3. write data
             // options: Data.WritingOptions.atomic
             try data.write(to: getDataFilePath(), options: .atomic)
         // 4. catch error
         }catch{
             // 5. deal with error
             print("Error encoding item array: \(error.localizedDescription)")
         }
     }
     
     func loadChecklistItems(){
         // 1. create a Data object
         if let data = try? Data(contentsOf: getDataFilePath()){
             // 2. create a PropertyListDecoder object
             let decoder = PropertyListDecoder()
             do {
                 // 3. decode, put result into items
                 checklist.items = try decoder.decode([ChecklistItem].self, from: data)
             }catch{
                 print("Error decoding item arry: \(error.localizedDescription)")
             }
             
         }
     }

     */
}

