//
//  AllListsViewController.swift
//  Checklists
//
//  Created by user206341 on 10/21/21.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    

    let cellIdentifier = "ChecklistCell"
//    var lists = [Checklist]()
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // enable large title
        navigationController?.navigationBar.prefersLargeTitles = true

        // connect cellIdentifier with cell Class,
        // TableCell will be default style, we want subtitle style, use another way
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
                
//        // some initial dummy data
//        var list = Checklist(name: "Birthdays")
//        lists.append(list)
//
//        list = Checklist(name: "Groceries")
//        lists.append(list)
//
//        list = Checklist(name: "Cool Apps")
//        lists.append(list)
//
//        list = Checklist(name: "To Do")
//        lists.append(list)
//
//        // dummy data for items
//        for list in lists {
//            let item = ChecklistItem()
//            item.text = "Item for \(list.name)"
//            list.items.append(item)
//        }
        
        // load data
//        loadChecklist()

    }

    // is called before the view controller becomes visible
    override func viewWillAppear(_ animated: Bool) {
        print("TAG AllListViewController viewWillAppear()...")
        
        super.viewWillAppear(animated)
        
        // usually user changed data in other scene, reloadData() is a easy way to sync tableView's data
        tableView.reloadData()
    }

    // is called after the view controller becomes visible
    override func viewDidAppear(_ animated: Bool) {
        print("TAG AllListViewController viewDidAppear()...")
        
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
//        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        let index = dataModel.indexOfSelectedChecklist

        // change to use more strict condition
        // if index != -1 {

        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusableCell: if there's reusable cell, get one to return, otherwise, create a new UITableViewCell with default style
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // create a new UITableViewCell with subtitle style
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        }else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        // give every list a default name
//        cell.textLabel!.text = "List \(indexPath.row)"
        
        // update cell information
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton

        // add an image for every checklist
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        // show detail info of the cell
        let itemCount = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "No items"
        }else {
            cell.detailTextLabel!.text = itemCount == 0 ? "All Done":"\(itemCount) Remaining"
        }
        
//        cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Remaining"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        // show segue by code instead of by storyboard
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        
        // save checklist index into UserDefaults
//        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        dataModel.indexOfSelectedChecklist = indexPath.row
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        // change UI
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
       /* these code generated by Xcode, they're not the same with the book
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteitems(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        */
    }

    // show next view controller by code
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        // prepare the data give to next scene
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        // show the next view controller
        navigationController?.pushViewController(controller, animated: true)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        }else if segue.identifier == "AddChecklist" {
            // Pass the selected object to the new view controller.
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }

    // MARK: - List Detail View Controller Delegates
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
//        print("TAG AllListsViewController ListDetailViewControllerDidCancel()")
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
//        let index = dataModel.lists.count

        dataModel.lists.append(checklist)
        dataModel.sortChecklists()

        // simpler way to change UI, because there're not too much cells in a tableView, it's fine to do like this
        tableView.reloadData()
        
        // change UI
//        let indexPath = IndexPath(row: index, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        
        // change UI
        tableView.reloadData()
        
//        if let index = dataModel.lists.firstIndex(of: checklist) {
//            // data already changed
//
//            // change UI
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                cell.textLabel!.text = checklist.name
//            }
//        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation Controller Delegates
    // is called whenever the navigation shows a new screen
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("TAG navigationController(_:willShow:animated:)... ")
        // will show navigation controller ? means was the back button tapped?
        if viewController === self {    // use == is ok too, === is better
            // -1 means no valid index
//            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
