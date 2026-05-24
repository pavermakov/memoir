//
//  Note.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftData
import Foundation

@Model
final class Note {
    var title: String
    var date: Date
    var message: String
    var friends: [Friend]?
    
    init(title: String, date: Date, message: String, friends: [Friend]? = nil) {
        self.title = title
        self.date = date
        self.message = message
        self.friends = friends
    }
}
