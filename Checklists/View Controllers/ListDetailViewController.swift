//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by user206341 on 10/21/21.
//

//import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    var iconName = "Folder"
    
    override func viewDidLoad() {
        // edit checklist detail info
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }

        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // before show next segue, register self as delegate for the destination scene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if indexPath.section == 1 {
            // will respond if user tapped the icon section
//            return indexPath
//        }else {
            // will not respond
//            return nil
//        }
        
        // simple way to code
        return indexPath.section == 1 ? indexPath : nil
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
//        print("TAG ListDetailViewController cancel()")
        delegate?.ListDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        // edit checklistToEdit
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.ListDetailViewController(self, didFinishEditing: checklist)
        }else{  // add a new checklist
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.ListDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        
        return true
    }
    
    // MARK: - Icon Picker Delegates
    func iconPicker(_ picker: UITableViewController, didPick iconName: String) {
        self.iconName = iconName
        
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }

}
