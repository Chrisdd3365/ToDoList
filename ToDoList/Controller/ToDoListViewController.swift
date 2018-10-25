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
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    var tasks = [ToDoObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTasksIntoTableView()
    }
    
    @IBAction func plusButtonTapped() {
        addTask()
    }
    
    @IBAction func resetButtonTapped() {
        
    }
    
    private func addTask() {
        let alert = UIAlertController(title: "Add new task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Task"
        }
        let action = UIAlertAction(title: "Post", style: .default) { _ in
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
