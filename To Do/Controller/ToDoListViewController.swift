//
//  ViewController.swift
//  To Do
//
//  Created by Raymond Tsang on 9/21/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var tasks = [Task]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadTasks()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.taskName
        
        cell.accessoryType = task.taskCompleted ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tasks[indexPath.row].taskCompleted = !tasks[indexPath.row].taskCompleted
        
        saveTasks()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new task to do!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let task = Task()
            task.taskName = textField.text!
            self.tasks.append(task)
            
            self.saveTasks()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Task"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveTasks() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(tasks)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding")
        }
        
        tableView.reloadData()
    }
    
    func loadTasks() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                tasks = try decoder.decode([Task].self, from: data)
            } catch {
                print("error decoding")
            }
        }
    }
    
}

