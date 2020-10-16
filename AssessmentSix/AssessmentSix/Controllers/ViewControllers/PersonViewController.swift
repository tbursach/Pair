//
//  PersonViewController.swift
//  AssessmentSix
//
//  Created by Trevor Bursach on 10/16/20.
//

import UIKit

class PersonViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var personListTableView: UITableView!
    
    //MARK: - Properties
    
    var pairs: [[Person]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        PersonController.shared.load()
        randomize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    //MARK: - Actions
   
    @IBAction func addPersonButtonTapped(_ sender: Any) {
        presentAddPersonAlert(nil)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        randomize()
    }
    
    //MARK: - Helper Functions
    
    func randomize() {
        var random: [[Person]] = []
        var new: [Person] = []
        
        for people in PersonController.shared.people.shuffled() {
            if new.count < 2 {
                new.append(people)
            } else if new.count == 2 {
                random.append(new)
                new = []
                new.append(people)
            }
        }
        if new.count > 0 {
            random.append(new)
        }
        pairs = random
        updateViews()
    }
    
    func setUpViews() {
        personListTableView.delegate = self
        personListTableView.dataSource = self
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.personListTableView.reloadData()
        }
    }
    
    func presentAddPersonAlert(_ person: Person?) {
        let alertController = UIAlertController(title: "Add Person", message: "Add someone new to the list.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Person name here"
            textField.autocapitalizationType = .words
            
        }
        
        let addPersonAction = UIAlertAction.init(title: "Add", style: .default) { (_) in
            guard let nameText = alertController.textFields?.first?.text, !nameText.isEmpty else { return }
            
            PersonController.shared.createPerson(personName: nameText)
            self.updateViews()
            self.randomize()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addPersonAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
} // END OF CLASS

extension PersonViewController: UITableViewDelegate, UITableViewDataSource {
    
    
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Group \(section + 1)"
        
        }
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return pairs.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pairs[section].count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
            
            let row = indexPath.row
            let section = indexPath.section
            let person = pairs[section][row]
            
            cell.textLabel?.text = person.name
            
            return cell
            
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let section = indexPath.section
            let personToDelete = pairs[section][row]
            
            PersonController.shared.deletePerson(personToDelete: personToDelete)
            randomize()
        }
    }
}
