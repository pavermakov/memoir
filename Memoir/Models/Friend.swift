//
//  Friend.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftData

@Model
final class Friend {
    var firstName: String
    var lastName: String
    var age: Int?
    
    init(firstName: String, lastName: String, age: Int? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}
