//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Simon Italia on 5/16/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    var checklistItem: ChecklistItem?
    
    weak var delegate: ChecklistItemDetailDelegate?
    //Weak means if object ever gets recclaimed in memory, this property will become nil. It's not being held on to
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var itemDetailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set DetailVC as delegate
        itemDetailTextField.delegate = self
        
        //Navigation Bar properties
        navigationItem.largeTitleDisplayMode = .never
        
        //Set nav title
        //if editing item
        if let checklistItem = checklistItem {
            title = "Edit Item"
                //title is a nav controller property
            itemDetailTextField.text = checklistItem.text
        
        //If adding new item
        } else {
            title = "Add New Item"
            doneButton.isEnabled = false
        }
    }
    
    //Cancel Add new or edit item
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
        delegate?.checklistItemDetailDidCancel(self)
    }
    
    //Handle when user is done
    @IBAction func done() {
        
        //If existing item is edited
        if let checklistItem = checklistItem {
            checklistItem.text = itemDetailTextField.text!
            delegate?.checklistItemDetailDidFinishEditing(self, didFinishEditing: checklistItem)
        
        //If new item is added
        } else {
            let checklistItem = ChecklistItem(text: itemDetailTextField.text!, checked: false)
            
            delegate?.checklistItemDetailDidFinishAdding(self, didFinishAdding: checklistItem)
          }
        
        //Save data to disk
        delegate?.saveData()
    }

    //Remove text field highlighting
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //To force text field/label to be first responder (first view) when + / add new checklist item button is tapped
    override func viewWillAppear(_ animated: Bool) {
        itemDetailTextField.becomeFirstResponder()
    }
    
    //Detect when user interacts with TextField
    @IBAction func itemDetailTextFieldEdited(_ sender: UITextField) {

    }
    

    //This method is called each time a user enters a character into the UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        //Handle Done button when editing item text
        let existingText = textField.text!
        let stringRange = Range(range, in: existingText)
        let changedText = existingText.replacingCharacters(in: stringRange!, with: string)
        
        if changedText.isEmpty {
            doneButton.isEnabled = false

        } else {
            doneButton.isEnabled = true
        }
        
        return true
    }
    
}
