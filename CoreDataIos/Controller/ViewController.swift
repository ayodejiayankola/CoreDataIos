//
//  ViewController.swift
//  CoreDataIos
//
//  Created by Ayodejii Ayankola on 12/10/2021.
//

import UIKit
import CoreData



// Filtering is to return data based on certain condition while sorting is to return based on ascending / descending order
class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputFilterText: UITextField!
    
    
    //1. Refrence to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //  Data for the table
    var items: [Person]?
    
    // Variable to search for or filter with
    var filteredVariable: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Get items from Core Data
        fetchPeople()
        relationshipDemo()
    }
    
    //  MARK:- Entites and relationship
    func relationshipDemo(){
        // Create a family
        let family = Family(context: self.context)
        family.name = "Abc Family"
        
        // Create a person
        let  person = Person(context: self.context)
        person.name = "MAggie"
        person.family = family
        
//      family.addToPeople(person)
        print("This is family \(family.people)")
        
        //Save context
        do {
            try  self.context.save()
        } catch {
            //Error saving Data
        }
    }
    
    //MARK:- Fetch Data from core data
    func fetchPeople(){
        //   fetch data from core data to display in the table view
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            //Set the  sorting on the request
//            let sort = NSSortDescriptor(key: "name", ascending: false)
//            request.sortDescriptors = [sort]
         
//          request.fetchLimit = 3
            self.items =  try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }

    
    @IBAction func didTapAddButton(_ sender: Any) {
        
        //MARK:- Saving Data to coreData
        
        //Create Alert
        let alertController = UIAlertController(
            title: "Add Person",
            message: "What is the name of person ?",
            preferredStyle: .alert)
        alertController.addTextField()
        
        //Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            //Get the textfield for the alert
            let textfield = alertController.textFields![0]
            //Create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textfield.text
            newPerson.age = 30
            newPerson.gender = "Male"
            
            // Save The Data
            do {
                try  self.context.save()
            } catch {
                //Error saving Data
            }
            //Re-fetch the data
            self.fetchPeople()
        }
        
        //Add button
        alertController.addAction(submitButton)
        //Show Alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        self.filteredVariable = inputFilterText.text
        
        
        //   fetch data from core data to display in the table view
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
//            Set the filtering  on the request
            let pred = NSPredicate(format: "name CONTAINS %@", filteredVariable!)
//            let pred = NSPredicate(format: "name CONTAINS %@", filteredVariable as! CVarArg)
            request.predicate = pred
            
//            //Set the  sorting on the request
//            let sort = NSSortDescriptor(key: "name", ascending: false)
//            request.sortDescriptors = [sort]
         
//          request.fetchLimit = 3
            self.items =  try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
}







// MARK: - UITableViewDelegate - Edit Data in core data
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected Person
        let personToUpdate = self.items![indexPath.row]
        
        // Create alert
        let alertController = UIAlertController(
            title: "Update Person",
            message: "Please update the name of person in following field ?",
            preferredStyle: .alert)
        alertController.addTextField()
        let textfield = alertController.textFields![0]
        textfield.text = personToUpdate.name
        
        // Configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textfield =  alertController.textFields![0]
            
            // Edit name property of person object
            personToUpdate.name = textfield.text
            
            // Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            // Re-fetch the data
            self.fetchPeople()
        }
        
        // Add Button
        alertController.addAction(saveButton)
        
        // show alert
        self.present(alertController, animated: true, completion: nil)
        
    }
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
        cell.textLabel?.text = person?.name
        return cell
    }
    
    //MARK:- Delete Data from core data
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { (action, view, completionHandler) in
            // Which person to be remove
            let personToRemove = self.items![indexPath.row]
            
            //Remove the person
            self.context.delete(personToRemove)
            
            // Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // Refetch the data
            self.fetchPeople()
        }
        
        //Return swipe Actions
        return UISwipeActionsConfiguration(actions: [action])
    }
}

