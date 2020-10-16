//
//  Person.swift
//  AssessmentSix
//
//  Created by Trevor Bursach on 10/16/20.
//

import Foundation

class Person: Codable {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
} // End of Class

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}
