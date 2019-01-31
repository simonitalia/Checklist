//
//  ViewController.swift
//  Checklists
//
//  Created by Simon Italia on 5/12/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, ChecklistItemDetailDelegate {
    
    var checklistItems: [ChecklistItem]
    
    @IBAction func addItem(_ sender: Any) {
        
        let newRowIndex = checklistItems.count //store number of rows
        let item = ChecklistItem()
        
        var titles = ["Sports", "Work", "Home", "I need something to do"]
        let randomTitle = arc4random_uniform(UInt32(titles.count))
        let title = titles[Int(randomTitle)]
        item.text = title
        item.checked = true
        // set checked / unchecked state of item / row
        checklistItems.append(item)
        //append the item (new row) to the checklist array
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //call the tableview and call the insert rows method to insert just a row (not the content) Content is inserted by the data source
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        checklistItems = [ChecklistItem]() //Declare checklist array of Checklist item class
        
        let row0Item = ChecklistItem() //Reference ChecklistItem class
        row0Item.text = "Walk the Dog"
        row0Item.checked = false
        checklistItems.append(row0Item) // Adds this item to the Checklist Array
        
        let row1Item = ChecklistItem() //Reference ChecklistItem class
        row1Item.text = "Brush teeth"
        row1Item.checked = false
        checklistItems.append(row1Item)
        
        let row2Item = ChecklistItem() //Reference ChecklistItem class
        row2Item.text = "Learn iOS Development"
        row2Item.checked = false
        checklistItems.append(row2Item)
        
        let row3Item = ChecklistItem() //Reference ChecklistItem class
        row3Item.text = "Soccer Practice"
        row3Item.checked = false
        checklistItems.append(row3Item)
        
        let row4Item = ChecklistItem() //Reference ChecklistItem class
        row4Item.text = "Eat ice cream"
        row4Item.checked = false
        checklistItems.append(row4Item)
        
        super.init(coder: aDecoder)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            //Adds swipe to delete button to row, but doesn't actually delete the row. See susbequent code...
        
        checklistItems.remove(at: indexPath.row)
            // Deletes row from table
        
        //Show user row has been deleted
        /*let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)*/
        
        tableView.reloadData()
    }
    
    //Following method called to determine how many table view cells are returned in the current table view section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklistItems[indexPath.row]
            item.checkmarkToggle()
                //Calls toggleChecked function from Checklistitem class
        
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklistItems[indexPath.row]
        
        configureText(for: cell, with: item)
        
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
            label.textColor = UIColor.green
            
        } else {
            label.text = ""
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
                controller.itemToEdit = checklistItems[indexPath.row]
            }
        }
    }
    
    //ChecklistItemDetailDelegate() protocol methods
    func checklistItemDetailDidCancel(_ controller: DetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    //Inform VC when user has finished adding a new item
    func checklistItemDetailDidFinishAdding(_ controller: DetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklistItems.count
        checklistItems.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    //Inform VC when user has finished editing an item
    func checklistItemDetailDidFinishEditing(_ controller: DetailViewController, didFinishEditing item: ChecklistItem) {
        
        if let index = checklistItems.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }

}

