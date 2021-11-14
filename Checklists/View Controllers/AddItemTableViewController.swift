//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by user206341 on 10/18/21.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: AnyObject{
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem, _ index:Int)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet var shouldRemindSwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?  // itemToEdit could be nil
    var indexItemToEdit: Int?
    
    override func viewDidLoad() {
        print("TAG ItemDetailViewController viewDidLoad()...")
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.largeTitleDisplayMode = .never
        
        // when edit: change title and textField
        if let item = itemToEdit {
            title = "Edit item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            
            // add due date reminder
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
    }

    // this func is invoked after viewDidLoad()
    // set textField as the first responder
    override func viewWillAppear(_ animated: Bool) {
        print("TAG ItemDetailViewController viewWillAppear()...")
        textField.becomeFirstResponder()
    }

    // MARK: - Table View Delegates
    // disable cell selection
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    	
    // MARK: - Text Field Delegates
    // every time user type in the textField,this func is invoked
    // when new text is empty, disable the done button
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("TAG textField(_:shouldChangeCharactersIn:)()... ")
        
        let oldText = textField.text!
        // change NSRange into Range, NSRange used by Objective-C
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        // when new text is empty, disable the done button
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    // when Clear Button is clicked, disable the done button
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    // MARK: - Actions
    @IBAction func cancel(){
//        navigationController?.popViewController(animated: true)
        delegate?.ItemDetailViewControllerDidCancel(self)
    }

    @IBAction func done(){
//        print("TAG Contents of textField: \(textField.text!)")
//        navigationController?.popViewController(animated: true)
                
        if let item = itemToEdit {
            item.text = textField.text!
            
            // add due date reminder
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            
            item.scheduleNotification()
            
            delegate?.ItemDetailViewController(self, didFinishEditing: item, indexItemToEdit!)
        }else{
            let item = ChecklistItem()
            item.text = textField.text!

            // add due date reminder
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date

            item.scheduleNotification()

            // transmit data back to ChecklistViewController
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func shouldRemindToggled(_ remindSwitch: UISwitch){
        textField.resignFirstResponder()
        
        // when user change the switch on at the first time, will request authorization
        // from the second time, will not ask again
        if remindSwitch.isOn {
            print("TAG shouldRemindToggled() call requestAuthorization()...")
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert]){_, _ in
                // do nothing
            }
        }
    }
}
