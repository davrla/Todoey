//
//  ViewController.swift
//  Todoey
//
//  Created by David Vrla on 27/05/2019.
//  Copyright © 2019 David Vrla. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("todoItems.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        retrieveData()
//        let item1 = Item()
//        item1.title = "New item"
//        item1.done = true
//        itemArray.append(item1)
//
//        let item2 = Item()
//        item2.title = "New item 2"
//        item2.done = false
//        itemArray.append(item2)
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "todoeItems") as? [Item] {
//            itemArray = items
//        }
    }

    
    //MARK -  Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")
        let item = itemArray[indexPath.row]
        cell?.textLabel?.text = item.title
        
        
        cell?.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell?.accessoryType = .checkmark
//        } else {
//            cell?.accessoryType = .none
//        }
        
        return cell!
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
        
    }
    
    //MARK – Add new item actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Todoey item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
    }
    
    func retrieveData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray =   try context.fetch(request)
        }catch {
            print("error")
        }
    }

}
