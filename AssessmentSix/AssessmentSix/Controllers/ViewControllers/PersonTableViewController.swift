//
//  PersonTableViewController.swift
//  AssessmentSix
//
//  Created by Trevor Bursach on 10/16/20.
//

import UIKit

class PersonTableViewController: UITableViewController {

    //MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Helper Functions
    
    func presentAddPersonAlert(_ person: Person?) {
        let alertController = UIAlertController(title: "Add Person", message: "Add someone new to the list.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Person name here"
            textField.autocapitalizationType = .words
            
            if let person = person {
                textField.text = person.name
            }
        }
        
        let addPersonAction = UIAlertAction.init(title: "Add", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            
            if let person = person {
                person.name = text
                PersonController.shared.createPerson(personName: text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addPersonAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        
        let person = PersonController.shared.people[indexPath.row]
        
        cell.textLabel?.text = person.name


        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToDelete = PersonController.shared.people[indexPath.row]
            PersonController.shared.deletePerson(personToDelete: personToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
} // END OF CLASS
