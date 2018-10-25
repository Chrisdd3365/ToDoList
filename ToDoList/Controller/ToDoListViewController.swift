//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Christophe DURAND on 25/10/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var toDoListTableView: UITableView!
    
    //MARK: - Properties
    var tasks = [ToDoObject]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTasksIntoTableView()
    }
    
    //MARK: - Action
    @IBAction func plusButtonTapped() {
        addTask()
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        removeTask()
    }
    
    //MARK: - Methods
    private func addTask() {
        let alert = UIAlertController(title: "Add new task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Task"
        }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            let task = alert.textFields!.first!.text!
            let toDoObject = ToDoObject(context: AppDelegate.viewContext)
            toDoObject.task = task
            self.tasks.append(toDoObject)
            self.toDoListTableView.reloadData()
            self.saveViewContext()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func removeTask() {
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoObject")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Deleted all my data in ToDoObject error : \(error) \(error.userInfo)")
        }
        self.tasks.removeAll()
        toDoListTableView.reloadData()
        saveViewContext()
    }
    
    private func saveViewContext() {
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func displayTasksIntoTableView() {
        let request: NSFetchRequest<ToDoObject> = ToDoObject.fetchRequest()
        do {
            let tasks = try AppDelegate.viewContext.fetch(request)
            self.tasks = tasks
            self.toDoListTableView.reloadData()
        } catch let error as NSError {
            print(error)
        }
    }
}
//Extension UITableView
extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = tasks[indexPath.row].task
        return cell
    }
}
