//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Simon Italia on 5/16/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

//adding colon class ensures this will only work on classes. running on struct or enumeration will generate a compile error
protocol ItemDetailViewControllerDelegate: class {
    
    func ItemDetailViewControllerDidCancel(_ controller: DetailViewController)
        //When cancelling item add
    
    func ItemDetailViewController(_ controller: DetailViewController, didFinishAdding item: ChecklistItem)
        // When adding an item
    
    func ItemDetailViewController(_ controller: DetailViewController, didFinishEditing item: ChecklistItem)
}

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    var itemToEdit: ChecklistItem?
    
    weak var delegate: ItemDetailViewControllerDelegate? //Weak means if object ever gets recclaimed in memory, this property will become nil. It's not being held on to
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
                //title is a built in property on navigation controller
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    //Cancel Add row button method
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.ItemDetailViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
          }
    }

    //Remove text field highlighting
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //To force text field/label to be first responder when + / add new checklist item button is tapped
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    //This method is called each time a user enters a character into a text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)
        let newText = oldText.replacingCharacters(in: stringRange!, with: string)
    
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
          }
        return true
    }
}
