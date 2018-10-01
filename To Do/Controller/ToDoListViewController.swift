//
//  ViewController.swift
//  To Do
//
//  Created by Raymond Tsang on 9/21/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    var tasks : Results<Task>?
    
    var selectedCategory : Category? {
        didSet {
            loadTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let color = selectedCategory?.color
            else {fatalError()}
        updateNavBar(withHexCode: color)
        
        title = selectedCategory!.categoryName
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: NavBar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode : String) {
        guard let navBar = navigationController?.navigationBar
            else {fatalError("Nav controller does not exist")}
        guard let navBarColor = UIColor(hexString: colorHexCode)
            else {fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let task = tasks?[indexPath.row] {
            cell.textLabel?.text = task.taskName
            cell.accessoryType = task.taskCompleted ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(tasks!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = tasks?[indexPath.row] {
            do {
                try realm.write {
                    item.taskCompleted = !item.taskCompleted
                }
            } catch {
                print("error saving task")
            }
        }
        
        tableView.reloadData()
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new task to do!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let task = Task()
                        task.taskName = textField.text!
                        task.dateCreated = Date()
                        currentCategory.items.append(task)
                    }
                } catch {
                    print("error adding")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Task"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods

    func loadTasks() {

        tasks = selectedCategory?.items.sorted(byKeyPath: "taskName", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let task = tasks?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(task)
                }
            } catch {
                print("error deleting task")
            }
        }
    }
    
}

//MARK - UISearchBarDelegate methods

extension ToDoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        tasks = tasks?.filter("taskName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTasks()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
