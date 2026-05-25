//
//  Friend.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftData
import SwiftUI

@Model
final class Friend {
    var firstName: String
    var lastName: String
    var age: Int?
    @Attribute(.externalStorage) var profileImageData: Data?
    
    init(firstName: String, lastName: String, age: Int? = nil, profileImageData: Data? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.profileImageData = profileImageData
    }
    
    var profileImage: Image? {
        guard let data = profileImageData,
              let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
}
