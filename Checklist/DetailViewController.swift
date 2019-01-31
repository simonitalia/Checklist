//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Simon Italia on 5/16/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    var itemToEdit: ChecklistItem?
    
    weak var delegate: ChecklistItemDetailDelegate?
        //Weak means if object ever gets recclaimed in memory, this property will become nil. It's not being held on to
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var itemDetailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
                //title is a nav controller property
            itemDetailTextField.text = item.text
            doneButton.isEnabled = true
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
        if let itemToEdit = itemToEdit {
            itemToEdit.text = itemDetailTextField.text!
            delegate?.checklistItemDetailDidFinishEditing(self, didFinishEditing: itemToEdit)
        
        //If new item is added
        } else {
            let item = ChecklistItem()
            item.text = itemDetailTextField.text!
            item.checked = false
            delegate?.checklistItemDetailDidFinishAdding(self, didFinishAdding: item)
          }
    }

    //Remove text field highlighting
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //To force text field/label to be first responder when + / add new checklist item button is tapped
    override func viewWillAppear(_ animated: Bool) {
        itemDetailTextField.becomeFirstResponder()
    }
    
    //This method is called each time a user enters a character into a text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)
        let newText = oldText.replacingCharacters(in: stringRange!, with: string)
    
        if newText.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
          }
        return true
    }
}
