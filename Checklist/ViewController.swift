//
//  ViewController.swift
//  Checklists
//
//  Created by Simon Italia on 5/12/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, ChecklistItemDetailDelegate {
    
    var checklistItems = [ChecklistItem]()
//    var checklistItem = ChecklistItem(text: "", checked: false, checkedLabel: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Display (if any) saved Object data on app launch
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: "checklistItems") as? Data {
            if let decodedSavedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [ChecklistItem] {
                checklistItems = decodedSavedData ?? [ChecklistItem]()
            }
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Enable swipe to delete button to row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //Remove checklistItem row
        checklistItems.remove(at: indexPath.row)
        
        tableView.reloadData()
        
        //Update the saved data so removed row isn't load on app launch
        saveData()
    }
    
    //Following method called to determine how many table view cells are returned in the current table view section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }
    
    //Handle toggling of checkmark indicator
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let cell = tableView.cellForRow(at: indexPath) {
            let checklistItem = checklistItems[indexPath.row]
        
            checklistItem.checkmarkToggle()
                //Calls toggleChecked function from Checklistitem class
        
            //Save checkmark state to disk
            saveData()
        
            //Pass in checklistItem to method to set the checkmark label
            configureCheckmark(for: cell, with: checklistItem)

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let checklistItem = checklistItems[indexPath.row]
        
        //Set Text label
        configureText(for: cell, with: checklistItem)
        
        //Set checkmark label
        configureCheckmark(for: cell, with: checklistItem)
        
        return cell
    }
    
    func configureText(for cell: UITableViewCell, with checklistItem: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = checklistItem.text
    }
    
    func configureCheckmark(for cell: UITableViewCell, with checklistItem: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if checklistItem.checked {
            label.text = "√"
//            checklistItem.checkedLabel = "√"
            
        } else {
            label.text = ""
//            checklistItem.checkedLabel = ""
        }
    }
    
    //Prepare transition to DetailViewController via Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //sender = object that called the prepare function
        
        //Add new item
        if segue.identifier == "NewItem" {
            let controller = segue.destination as! DetailViewController
            controller.delegate = self
        
        //Edit existing item
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! DetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.checklistItem = checklistItems[indexPath.row]
            }
        }
    }
    
    //ChecklistItemDetailDelegate() protocol methods
    func checklistItemDetailDidCancel(_ controller: DetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    //Inform VC when user has finished adding a new item
    func checklistItemDetailDidFinishAdding(_ controller: DetailViewController, didFinishAdding checklistItem: ChecklistItem) {
        
        let newRowIndex = checklistItems.count
        checklistItems.append(checklistItem)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
        //Save new checklistItem data object to disk
        saveData()
        
    }
    
    //Inform VC when user has finished editing an item
    func checklistItemDetailDidFinishEditing(_ controller: DetailViewController, didFinishEditing checklistItem: ChecklistItem) {
        
        if let index = checklistItems.index(of: checklistItem) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: checklistItem)
                
                //Save edited data
                saveData()
            }
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    //Save/write data (checklistItems array) to disk method
    func saveData() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: checklistItems, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "checklistItems")
        }
    }
}

