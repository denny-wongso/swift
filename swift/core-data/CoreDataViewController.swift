//
//  CoreDataViewController.swift
//  swift
//
//  Created by Denny Wongso on 22/12/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var list: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillTerminate(notification:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        do {
            list = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc func applicationWillTerminate(notification: Notification) {
        self.saveContext()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func addNewTodo(_ sender: Any) {
        let alert = UIAlertController(title: "New Task",
                                      message: "Add a Task",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {[unowned self] action in
            guard let textField = alert.textFields?.first,
                  let taskToSave = textField.text else {
                return
            }
            self.save(name: taskToSave, date: Date())
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField(configurationHandler: {(textfiled) in
            textfiled.placeholder = "name"
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String, date: Date) {
        
        // 1
        let managedContext =  self.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext)!
        
        let todo = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        todo.setValue(name, forKeyPath: "task")
        todo.setValue(date, forKey: "date")
        todo.setValue(UUID(), forKey: "id")
        
        
        // 4
        do {
            try managedContext.save()
            list.append(todo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        let task = list[indexPath.row]
        cell.textLabel?.text = task.value(forKeyPath: "task") as? String
        let date = task.value(forKeyPath: "date") as? Date ?? Date()
        cell.detailTextLabel?.text = "\(date.ISO8601Format())"
        return cell
    }
}
