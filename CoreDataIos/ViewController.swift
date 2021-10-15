//
//  ViewController.swift
//  CoreDataIos
//
//  Created by Ayodejii Ayankola on 12/10/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController{

    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //Refrence to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //  Data for the table
    var items: [Person]?
     
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Get items from Core Data
        fetchPeople()
        
    }

    func fetchPeople(){
        //fetch data from core data to display in the table view
        do {
            self.items =  try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    
    
    
    
    @IBAction func didTapAddButton(_ sender: Any) {
        print("Did tap add button")
        
        let alertController = UIAlertController(
            title: "Add Person",
            message: "What is the name of person ?",
            preferredStyle: .alert)
        alertController.addTextField()
        //Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            //Get the textfield for the alert
            let textfield = alertController.textFields![0]
            print("This is it\(textfield.text)")
        }
        
         //Add button
        alertController.addAction(submitButton)
        //Show Alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    


}



// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alertController = UIAlertController(
//            title: "Update Person",
//            message: "Please update the name of person in following field ?",
//            preferredStyle: .alert)
//        let personToUpdate = self.items?[indexPath.row]
//
//        alertController.addTextField { (textField) in
//            if let name = personToUpdate?.name {
//                textField.text = name
//            }
//        }
//        alertController.addAction(.init(title: "Ok", style: .default, handler: { [weak self] (alertAction) in
//            let textField = alertController.textFields?.first
//
//            personToUpdate?.name = textField?.text
//
////            self?.saveInCoreData()
////
////            self?.fetchPeople()
//        }))
//        self.present(alertController, animated: true)
//    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Return the number of people
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self)) ?? UITableViewCell()
        
        let person = self.items?[indexPath.row]
        cell.textLabel?.text = "person?.name"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(
//            style: .destructive,
//            title: "Delete"
//        ) { (action, view, completionHandler) in
//            if let personToRemove = self.items?[indexPath.row] {
//
//                self.context.delete(personToRemove)
////
////                self.saveInCoreData()
////
//                print("Deleted: \(personToRemove.name ?? "")")
//                self.fetchPeople()
//            }
//        }
//
//        return UISwipeActionsConfiguration(actions: [action])
//    }
}

