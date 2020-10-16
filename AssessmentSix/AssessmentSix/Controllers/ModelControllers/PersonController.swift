//
//  PersonController.swift
//  AssessmentSix
//
//  Created by Trevor Bursach on 10/16/20.
//

import Foundation

class PersonController {
    
    //MARK: - Singleton
    
    static let shared = PersonController()
    
    //MARK: - Source Of Truth
    
    var people: [Person] = []
    
    //MARK: - CRUD Functions
    
    func createPerson(personName: String) {
        let newPerson = Person(name: personName)
        people.append(newPerson)
        save()
    }
    
    func deletePerson(personToDelete: Person) {
        guard let index = people.firstIndex(of: personToDelete) else { return }
        people.remove(at: index)
        save()
    }
    
    
    func createFileForPersistence() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = urls[0].appendingPathComponent("personRandomizer.json")
        return fileUrl
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsondPerson = try jsonEncoder.encode(people)
            try jsondPerson.write(to: createFileForPersistence())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func load() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let jsonData = try Data(contentsOf: createFileForPersistence())
            let decodedPerson = try jsonDecoder.decode([Person].self, from: jsonData)
            people = decodedPerson
        }catch {
            print(error)
            print(error.localizedDescription)
        }
    }

} // End of Class
