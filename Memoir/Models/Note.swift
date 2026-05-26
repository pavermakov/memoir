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
    @Relationship(inverse: \NotePhoto.note) var photos: [NotePhoto]?
    
    init(title: String, date: Date, message: String, friends: [Friend]? = nil, photos: [NotePhoto]? = nil) {
        self.title = title
        self.date = date
        self.message = message
        self.friends = friends
        self.photos = photos
    }
}
